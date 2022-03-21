import 'package:flutter/material.dart';
import 'package:messenger/constants/assets.dart';
import 'package:messenger/models/message_type.dart';

class MimeWidget extends StatelessWidget {
  final String mimi;
  final void Function(String, MessageType) onPressed;

  const MimeWidget({
    Key? key,
    required this.onPressed,
    required this.mimi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Image.asset(
        Assets.getMimi(mimi),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      onPressed: () => onPressed(mimi, MessageType.sticker),
    );
  }
}
