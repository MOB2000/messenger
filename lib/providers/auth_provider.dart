import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/services/fire_auth.dart';
import 'package:messenger/services/firestore.dart';

class MyAuthProvider extends ChangeNotifier {
  CustomUser get user => FireAuth.instance.user;

  Stream<QuerySnapshot> getUsers(String textSearch) {
    if (textSearch.isNotEmpty == true) {
      return Firestore.instance.firebaseFirestore
          .collection(Keys.users)
          .where(Keys.nickname, isEqualTo: textSearch)
          .where(Keys.id, isNotEqualTo: user.id)
          .snapshots();
    } else {
      return Firestore.instance.firebaseFirestore
          .collection(Keys.users)
          .where(Keys.id, isNotEqualTo: user.id)
          .snapshots();
    }
  }

  Future<bool> get isLoggedIn async => FireAuth.instance.isLoggedIn;

  Future<void> saveUser() async => FireAuth.instance.saveUser();

  Future<void> signOut() async => await FireAuth.instance.signOut();
}
