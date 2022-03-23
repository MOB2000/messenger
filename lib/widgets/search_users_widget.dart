import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/utils/de_bouncer.dart';

class SearchUsersWidget extends StatefulWidget {
  final void Function(String) onChange;

  const SearchUsersWidget({Key? key, required this.onChange}) : super(key: key);

  @override
  State<SearchUsersWidget> createState() => _SearchUsersWidgetState();
}

class _SearchUsersWidgetState extends State<SearchUsersWidget> {
  // String _textSearch = "";
  final searchBarTec = TextEditingController();
  final searchDeBouncer = DeBouncer(milliseconds: 300);
  final btnClearController = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search, color: kGreyColor, size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDeBouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                  } else {
                    btnClearController.add(false);
                  }
                  widget.onChange(value);
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: kSearchNickname,
                hintStyle: TextStyle(fontSize: 13, color: kGreyColor),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTec.clear();
                          btnClearController.add(false);
                          widget.onChange('');
                        },
                        child: const Icon(Icons.clear_rounded,
                            color: kGreyColor, size: 20))
                    : const SizedBox.shrink();
              }),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kGreyColor2,
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }
}
