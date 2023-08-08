import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  Firestore._();

  static final Firestore instance = Firestore._();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
}
