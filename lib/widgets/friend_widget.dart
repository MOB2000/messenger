import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/models/chat_page_arguments.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:messenger/utils/utilities.dart';

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
            Material(
              child: friend.photoUrl.isNotEmpty
                  ? Image.network(
                      friend.photoUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kThemeColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: kGreyColor,
                        );
                      },
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 50,
                      color: kGreyColor,
                    ),
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
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
          if (Utilities.isKeyboardShowing()) {
            Utilities.closeKeyboard(context);
          }
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
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
    );
  }
}
