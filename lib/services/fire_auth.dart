import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/services/firestore.dart';

class FireAuth {
  late CustomUser user;

  FireAuth._() {
    user = CustomUser(
      id: '',
      nickname: '',
      photoUrl: '',
      aboutMe: '',
    );
  }

  static final FireAuth instance = FireAuth._();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> get isLoggedIn async => firebaseAuth.currentUser != null;

  Future initUser() async {
    await Firestore.instance.firebaseFirestore
        .collection(Keys.users)
        .doc(firebaseAuth.currentUser?.uid ?? '')
        .get()
        .then((value) {
      if (value.exists) {
        user = CustomUser.fromDocument(value);
      }
    });
  }

  Future<void> saveUser() async {
    final user = firebaseAuth.currentUser!;

    final isExists = await Firestore.instance.firebaseFirestore
        .collection(Keys.users)
        .doc(user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        this.user = CustomUser.fromDocument(value);
      }
      return value.exists;
    });

    if (isExists) {
      return;
    }

    this.user = CustomUser.fromFirebaseUser(user, DateTime.now());

    Firestore.instance.firebaseFirestore
        .collection(Keys.users)
        .doc(user.uid)
        .set(this.user.toMap());
  }

  Future<void> signOut() async => await firebaseAuth.signOut();
}
