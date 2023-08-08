import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/models/chat_page_arguments.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:messenger/utils/utilities.dart';
import 'package:messenger/widgets/profile_image.dart';

class FriendWidget extends StatelessWidget {
  final CustomUser friend;

  const FriendWidget({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Row(
          children: <Widget>[
            ProfileImage(
              photoUrl: friend.photoUrl,
              size: 50,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        friend.nickname,
                        maxLines: 1,
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                    ),
                    if (friend.aboutMe.trim().isNotEmpty)
                      Container(
                        child: Text(
                          friend.aboutMe,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                            color: kPrimaryColor,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      )
                  ],
                ),
                margin: const EdgeInsets.only(left: 20),
              ),
            ),
          ],
        ),
        onPressed: () {
          Utilities.closeKeyboard(context);

          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: ChatPageArguments(
              peerId: friend.id,
              peerAvatar: friend.photoUrl,
              peerNickname: friend.nickname,
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(kGreyColor2),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10)
          .copyWith(top: 0),
    );
  }
}
