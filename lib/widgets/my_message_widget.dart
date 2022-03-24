import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger/constants/assets.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/message_type.dart';
import 'package:messenger/screens/full_photo_screen.dart';

class MyMessageWidget extends StatelessWidget {
  final Message messageChat;
  final int index;

  const MyMessageWidget({
    Key? key,
    required this.index,
    required this.messageChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (messageChat.type == MessageType.text)
            Container(
              child: Text(
                messageChat.content,
                style: const TextStyle(color: kPrimaryColor),
              ),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              width: 200,
              decoration: BoxDecoration(
                  color: kGreyColor2, borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.only(right: 10),
            ),
          if (messageChat.type == MessageType.image)
            Container(
              child: OutlinedButton(
                child: Material(
                  child: Image.network(
                    messageChat.content,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: const BoxDecoration(
                          color: kGreyColor2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        width: 200,
                        height: 200,
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
                      return Material(
                        child: Image.asset(
                          Assets.kImgNotAvailable,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                      );
                    },
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  clipBehavior: Clip.hardEdge,
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
              margin: const EdgeInsets.only(right: 10),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 15),
            child: Text(
              DateFormat('dd MMM kk:mm').format(messageChat.timestamp),
              style: const TextStyle(
                  color: kGreyColor, fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
