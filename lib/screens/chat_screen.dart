import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/models/chat_page_arguments.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/message_type.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/providers/chat_provider.dart';
import 'package:messenger/services/image_pick.dart';
import 'package:messenger/widgets/chat_input.dart';
import 'package:messenger/widgets/loading_widget.dart';
import 'package:messenger/widgets/message_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'ChatScreen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late String currentUserId;

  String groupChatId = "";

  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";

  void getChatGroupId(String currentUserId, String peerId) {
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
  }

  Future<void> pickImageGallery(
      ChatProvider chatProvider, String peerId) async {
    final imageFile = await ImagePick.instance.pickImageGallery();
    if (imageFile != null) {
      uploadFile(chatProvider, peerId);
    }
  }

  Future uploadFile(ChatProvider chatProvider, String peerId) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      isLoading = true;
    });
    try {
      final snapshot = await chatProvider.putFile(imageFile!, fileName);
      imageUrl = await snapshot.ref.getDownloadURL();
      onSendMessage(chatProvider, imageUrl, MessageType.image, peerId);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onSendMessage(
    ChatProvider chatProvider,
    String content,
    MessageType type,
    String peerId,
  ) {
    if (content.trim().isEmpty) {
      Fluttertoast.showToast(msg: kNothingToSend, backgroundColor: kGreyColor);
      return;
    }

    final message = Message(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    chatProvider.sendMessage(
      groupChatId,
      message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ChatPageArguments;

    getChatGroupId(authProvider.user.id, arguments.peerId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          arguments.peerNickname,
          style: const TextStyle(color: kPrimaryColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  if (messages.isEmpty) {
                    return const Center(child: Text(kStartSendMessages));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => MessageWidget(
                      index: index,
                      messageChat: Message.fromDocument(messages[index]),
                      friendPhotoUrl: arguments.peerAvatar,
                    ),
                  );
                }

                return const LoadingWidget();
              },
            ),
          ),
          ChatInput(
            onSendMessage: (value) {
              onSendMessage(
                chatProvider,
                value,
                MessageType.text,
                arguments.peerId,
              );
            },
            onPressedImage: () =>
                pickImageGallery(chatProvider, arguments.peerId),
          ),
        ],
      ),
    );
  }
}
