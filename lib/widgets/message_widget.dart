import 'package:flutter/material.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/widgets/friend_message_widget.dart';
import 'package:messenger/widgets/my_message_widget.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  final Message messageChat;
  final int index;
  final String friendPhotoUrl;

  const MessageWidget({
    Key? key,
    required this.index,
    required this.messageChat,
    required this.friendPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<AuthProvider>(context).user.id;

    bool isFromMe = messageChat.idFrom == currentUserId;

    return isFromMe
        ? MyMessageWidget(
            index: index,
            messageChat: messageChat,
          )
        : FriendMessageWidget(
            index: index,
            messageChat: messageChat,
            friendPhotoUrl: friendPhotoUrl,
          );
  }
}
