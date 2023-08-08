import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/services/fire_storage.dart';
import 'package:messenger/services/firestore.dart';

class ChatProvider {
  UploadTask putFile(File image, String fileName) {
    return FireStorage.instance.putFile(fileName, image);
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId) {
    return Firestore.instance.firebaseFirestore
        .collection(Keys.messages)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(Keys.timestamp)
        .snapshots();
  }

  Future<void> deleteMessage(
    String groupChatId,
    Message message,
  ) async {
    Firestore.instance.firebaseFirestore
        .collection(Keys.messages)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(message.timestamp.millisecondsSinceEpoch.toString())
        .delete();
  }

  void sendMessage(
    String groupChatId,
    Message message,
  ) {
    Firestore.instance.firebaseFirestore
        .collection(Keys.messages)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(message.timestamp.millisecondsSinceEpoch.toString())
        .set(message.toMap());
  }
}
