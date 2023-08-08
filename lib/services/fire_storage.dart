import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  FireStorage._();
  static final FireStorage instance = FireStorage._();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UploadTask putFile(String fileName, File image) {
    return _firebaseStorage.ref().child(fileName).putFile(image);
  }
}
