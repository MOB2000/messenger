import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';

class ChatInput extends StatelessWidget {
  final void Function(String) onSendMessage;
  final VoidCallback onPressedImage;

  ChatInput({
    Key? key,
    required this.onSendMessage,
    required this.onPressedImage,
  }) : super(key: key);

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kGreyColor2, width: 0.5)),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            child: IconButton(
              icon: const Icon(Icons.image),
              onPressed: onPressedImage,
              color: kPrimaryColor,
            ),
          ),
          Expanded(
            child: TextField(
              onSubmitted: (value) {
                onSendMessage(textEditingController.text);
                textEditingController.clear();
              },
              style: const TextStyle(color: kPrimaryColor, fontSize: 15),
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: kTypeYourMessage,
                hintStyle: TextStyle(color: kGreyColor),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                onSendMessage(textEditingController.text);
                textEditingController.clear();
              },
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
