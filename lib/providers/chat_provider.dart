import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/message_type.dart';
import 'package:messenger/services/fire_storage.dart';
import 'package:messenger/services/firestore.dart';

class ChatProvider {
  UploadTask putFile(File image, String fileName) {
    return FireStorage.instance.putFile(fileName, image);
  }

  Future<void> updateDataFirestore(
    String collectionPath,
    String docPath,
    Map<String, dynamic> dataNeedUpdate,
  ) async {
    Firestore.instance.firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return Firestore.instance.firebaseFirestore
        .collection(Keys.messages)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(Keys.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(
    String content,
    MessageType type,
    String groupChatId,
    String currentUserId,
    String peerId,
  ) {
    DocumentReference documentReference = Firestore.instance.firebaseFirestore
        .collection(Keys.messages)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    Message messageChat = Message(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toMap(),
      );
    });
  }
}
