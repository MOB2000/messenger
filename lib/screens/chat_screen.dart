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
import 'package:messenger/utils/utilities.dart';
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
  final _scrollController = ScrollController();

  String getChatGroupId(String currentUserId, String peerId) {
    if (currentUserId.compareTo(peerId) > 0) {
      return '$currentUserId-$peerId';
    } else {
      return '$peerId-$currentUserId';
    }
  }

  Future<void> pickImageGallery(
    ChatProvider chatProvider,
    String userId,
    String peerId,
  ) async {
    final imageFile = await ImagePick.instance.pickImageGallery();

    if (imageFile != null) {
      showWaitingDialog(
        context,
        () async {
          await uploadImage(chatProvider, userId, imageFile, peerId);
        },
      );
    }
  }

  Future uploadImage(
    ChatProvider chatProvider,
    String senderId,
    File imageFile,
    String peerId,
  ) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final snapshot = await chatProvider.putFile(imageFile, fileName);
      final imageUrl = await snapshot.ref.getDownloadURL();
      sendMessage(chatProvider, senderId, imageUrl, MessageType.image, peerId);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> sendMessage(
    ChatProvider chatProvider,
    String currentUserId,
    String content,
    MessageType type,
    String peerId,
  ) async {
    if (content.trim().isEmpty) {
      Fluttertoast.showToast(msg: kNothingToSend, backgroundColor: kGreyColor);
      return;
    }

    final message = Message(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now(),
      content: content,
      type: type,
    );

    chatProvider.sendMessage(
      getChatGroupId(currentUserId, peerId),
      message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<MyAuthProvider>(context);
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
              stream: chatProvider.getChatStream(
                getChatGroupId(authProvider.user.id, arguments.peerId),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  if (messages.isEmpty) {
                    return const Center(child: Text(kStartSendMessages));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) => MessageWidget(
                      index: index,
                      chatGroupId: getChatGroupId(
                          authProvider.user.id, arguments.peerId),
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
            onSendMessage: (value) async {
              await sendMessage(
                chatProvider,
                authProvider.user.id,
                value,
                MessageType.text,
                arguments.peerId,
              );
              scrollToEnd();
              try {
                scrollToEnd();
              } catch (e) {}
            },
            onPressedImage: () {
              pickImageGallery(
                chatProvider,
                authProvider.user.id,
                arguments.peerId,
              );
              scrollToEnd();
            },
          ),
        ],
      ),
    );
  }

  void scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
  }
}
