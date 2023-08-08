import 'package:flutter/material.dart';
import 'package:messenger/constants/strings.dart';

class DeleteDialog extends StatelessWidget {
  final String title;
  final void Function()? onDelete;

  const DeleteDialog({
    Key? key,
    required this.title,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: <Widget>[
        TextButton(
          child: const Text(kDelete),
          onPressed: onDelete,
        ),
        TextButton(
          child: const Text(kCancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
