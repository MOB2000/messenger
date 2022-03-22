import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/services/firestore.dart';

class FireAuth {
  FireAuth._();

  static final FireAuth instance = FireAuth._();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> get isLoggedIn async => firebaseAuth.currentUser != null;

  // TODO: replace with custom user when null add from firebase
  CustomUser get user => CustomUser.fromFirebaseUser(firebaseAuth.currentUser!);

  Future<void> saveUser() async {
    final user = firebaseAuth.currentUser!;

    final result = await Firestore.instance.firebaseFirestore
        .collection(Keys.users)
        .where(Keys.id, isEqualTo: user.uid)
        .get();

    final documents = result.docs;

    if (documents.isEmpty) {
      final cUser = CustomUser.fromFirebaseUser(user);
      Firestore.instance.firebaseFirestore
          .collection(Keys.users)
          .doc(user.uid)
          .set(
            cUser.toMap()
              ..addAll(
                {
                  Keys.createdAt:
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  Keys.chattingWith: null,
                },
              ),
          );
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
