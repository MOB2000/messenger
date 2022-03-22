import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/services/fire_auth.dart';
import 'package:messenger/services/firestore.dart';

class AuthProvider extends ChangeNotifier {
  CustomUser get user => FireAuth.instance.user;

  Stream<QuerySnapshot> getUsers(
    String pathCollection,
    int limit,
    String textSearch,
  ) {
    if (textSearch.isNotEmpty == true) {
      return Firestore.instance.firebaseFirestore
          .collection(pathCollection)
          .limit(limit)
          .where(Keys.nickname, isEqualTo: textSearch)
          .snapshots();
    } else {
      return Firestore.instance.firebaseFirestore
          .collection(pathCollection)
          .limit(limit)
          .snapshots();
    }
  }

  Future<bool> get isLoggedIn async => FireAuth.instance.isLoggedIn;

  Future<void> saveUser() async {
    FireAuth.instance.saveUser();
  }

  Future<void> signOut() async {
    await FireAuth.instance.signOut();
  }
}
