import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/models/chat_page_arguments.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/models/popup_choice.dart';
import 'package:messenger/pages/chat_screen.dart';
import 'package:messenger/pages/login_screen.dart';
import 'package:messenger/pages/settings_screen.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/providers/home_provider.dart';
import 'package:messenger/utils/de_bouncer.dart';
import 'package:messenger/utils/utilities.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState({Key? key});

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";

  late AuthProvider authProvider;
  late String currentUserId;
  late HomeProvider homeProvider;
  final searchDeBouncer = DeBouncer(milliseconds: 300);
  final btnClearController = StreamController<bool>();
  final searchBarTec = TextEditingController();

  final choices = <PopupChoice>[
    PopupChoice(title: kSettings, icon: Icons.settings),
    PopupChoice(title: kLogout, icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context);
    homeProvider = Provider.of<HomeProvider>(context);

    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
    listScrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onItemMenuPress(PopupChoice choice) {
    if (choice.title == kLogout) {
      handleSignOut();
    } else {
      Navigator.pushNamed(context, SettingsScreen.routeName);
    }
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: kThemeColor,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: const Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    const Text(
                      kExitApp,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      kAreYouSureToExitApp,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
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
                      kCancel,
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
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
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  Future<void> handleSignOut() async {
    authProvider.handleSignOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          kHome,
          style: TextStyle(color: kPrimaryColor),
        ),
        centerTitle: true,
        actions: <Widget>[buildPopupMenu()],
      ),
      body: WillPopScope(
        child: Column(
          children: <Widget>[
            buildSearchBar(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: homeProvider.getStreamFireStore(
                    Keys.pathUserCollection, _limit, _textSearch),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if ((snapshot.data?.docs.length ?? 0) > 0) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) =>
                            buildItem(context, snapshot.data?.docs[index]),
                        itemCount: snapshot.data?.docs.length,
                        controller: listScrollController,
                      );
                    } else {
                      return const Center(
                        child: Text(kNoUsers),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kThemeColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildSearchBar() {
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
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
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
                          setState(() {
                            _textSearch = "";
                          });
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

  Widget buildPopupMenu() {
    return PopupMenuButton<PopupChoice>(
      onSelected: onItemMenuPress,
      itemBuilder: (BuildContext context) {
        return choices.map((PopupChoice choice) {
          return PopupMenuItem<PopupChoice>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(
                    choice.icon,
                    color: kPrimaryColor,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    choice.title,
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      CustomUser userChat = CustomUser.fromDocument(document);
      if (userChat.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl.isNotEmpty
                      ? Image.network(
                          userChat.photoUrl,
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                            userChat.nickname,
                            maxLines: 1,
                            style: const TextStyle(color: kPrimaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                        ),
                        Container(
                          child: Text(
                            '$kAboutMe: ${userChat.aboutMe}',
                            maxLines: 1,
                            style: const TextStyle(color: kPrimaryColor),
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
                  peerId: userChat.id,
                  peerAvatar: userChat.photoUrl,
                  peerNickname: userChat.nickname,
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
    } else {
      return const SizedBox.shrink();
    }
  }
}
