import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger/services/fire_storage.dart';
import 'package:messenger/services/firestore.dart';

class SettingProvider {
  UploadTask putFile(
    String fileName,
    File image,
  ) {
    return FireStorage.instance.putFile(fileName, image);
  }

  Future<void> updateDataFirestore(
    String collectionPath,
    String path,
    Map<String, dynamic> dataNeedUpdate,
  ) async {
    Firestore.instance.firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }
}
