import 'package:flutter/material.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/providers/chat_provider.dart';
import 'package:messenger/widgets/delete_dialog.dart';
import 'package:messenger/widgets/friend_message_widget.dart';
import 'package:messenger/widgets/my_message_widget.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  final Message messageChat;
  final int index;
  final String friendPhotoUrl;
  final String chatGroupId;

  const MessageWidget({
    Key? key,
    required this.index,
    required this.messageChat,
    required this.friendPhotoUrl,
    required this.chatGroupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final currentUserId = Provider.of<MyAuthProvider>(context).user.id;

    bool isFromMe = messageChat.idFrom == currentUserId;

    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => DeleteDialog(
            title: kAreYouSureToDeleteMessage,
            onDelete: () {
              chatProvider.deleteMessage(chatGroupId, messageChat);
              Navigator.pop(context);
            },
          ),
        );
      },
      child: isFromMe
          ? MyMessageWidget(
              index: index,
              messageChat: messageChat,
            )
          : FriendMessageWidget(
              index: index,
              messageChat: messageChat,
              friendPhotoUrl: friendPhotoUrl,
            ),
    );
  }
}
