import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          color: kThemeColor,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: const Icon(
                      Icons.exit_to_app,
                      size: 30,
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.all(10),
                  ),
                  const Text(
                    kExitApp,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  kAreYouSureToExitApp,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            exit(0);
          },
          child: Row(
            children: <Widget>[
              Container(
                child: const Icon(
                  Icons.check_circle,
                  color: kPrimaryColor,
                ),
                margin: const EdgeInsets.only(right: 10),
              ),
              const Text(
                kYes,
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              Container(
                child: const Icon(
                  Icons.cancel,
                  color: kPrimaryColor,
                ),
                margin: const EdgeInsets.only(right: 10),
              ),
              const Text(
                kNo,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
