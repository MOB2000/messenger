import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/message_type.dart';
import 'package:messenger/screens/full_photo_screen.dart';
import 'package:messenger/widgets/profile_image.dart';

class FriendMessageWidget extends StatelessWidget {
  final Message messageChat;
  final int index;
  final String friendPhotoUrl;

  const FriendMessageWidget({
    Key? key,
    required this.index,
    required this.messageChat,
    required this.friendPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ProfileImage(
                size: 35,
                photoUrl: friendPhotoUrl,
              ),
              if (messageChat.type == MessageType.text)
                Container(
                  child: Text(
                    messageChat.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  width: 200,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.only(left: 10),
                ),
              if (messageChat.type == MessageType.image)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextButton(
                    child: ProfileImage(
                      size: 200,
                      photoUrl: messageChat.content,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        FullPhotoScreen.routeName,
                        arguments: messageChat.content,
                      );
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0))),
                  ),
                )
            ],
          ),
          Container(
            child: Text(
              DateFormat('dd MMM kk:mm').format(messageChat.timestamp),
              style: const TextStyle(
                  color: kGreyColor, fontSize: 12, fontStyle: FontStyle.italic),
            ),
            margin: const EdgeInsets.only(left: 50, top: 5, bottom: 5),
          ),
        ],
      ),
    );
  }
}
