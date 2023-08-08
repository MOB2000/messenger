import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/screens/login_screen.dart';
import 'package:messenger/screens/settings_screen.dart';
import 'package:messenger/widgets/exit_dialog.dart';
import 'package:messenger/widgets/friend_widget.dart';
import 'package:messenger/widgets/loading_widget.dart';
import 'package:messenger/widgets/search_users_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late MyAuthProvider authProvider;

  String _textSearch = '';

  Future<bool> onWillPop() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const ExitDialog(),
    );

    return false;
  }

  Future<void> signOut() async {
    authProvider.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<MyAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(kHome),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.perm_identity,
              color: kPrimaryColor,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsScreen.routeName),
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: kPrimaryColor,
            ),
            onPressed: signOut,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Column(
          children: <Widget>[
            SearchUsersWidget(
              onChange: (value) {
                setState(() {
                  _textSearch = value;
                });
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: authProvider.getUsers(_textSearch),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final friends = snapshot.data!.docs;
                    if (friends.isEmpty) {
                      return const Center(
                        child: Text(kNoUsers),
                      );
                    }
                    return ListView.builder(
                      itemCount: friends.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => FriendWidget(
                        friend: CustomUser.fromDocument(friends[index]),
                      ),
                    );
                  }
                  return const LoadingWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
