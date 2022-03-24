import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/utils/de_bouncer.dart';

class SearchUsersWidget extends StatefulWidget {
  final void Function(String) onChange;

  const SearchUsersWidget({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  State<SearchUsersWidget> createState() => _SearchUsersWidgetState();
}

class _SearchUsersWidgetState extends State<SearchUsersWidget> {
  final searchBarTec = TextEditingController();
  final searchDeBouncer = DeBouncer(milliseconds: 300);

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kGreyColor2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.search, color: kGreyColor, size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              decoration: const InputDecoration.collapsed(
                hintText: kSearchNickname,
                hintStyle: TextStyle(fontSize: 13, color: kGreyColor),
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (value) {
                searchDeBouncer.run(() {
                  if (value.isNotEmpty) {
                    setState(() {
                      isSearching = true;
                    });
                  } else {
                    setState(() {
                      isSearching = false;
                    });
                  }
                  widget.onChange(value);
                });
              },
            ),
          ),
          if (isSearching)
            GestureDetector(
              onTap: () {
                searchBarTec.clear();
                setState(() {
                  isSearching = false;
                });
                widget.onChange('');
              },
              child:
                  const Icon(Icons.clear_rounded, color: kGreyColor, size: 20),
            ),
        ],
      ),
    );
  }
}
