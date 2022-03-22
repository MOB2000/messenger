import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/constants/keys.dart';

class CustomUser {
  String id;
  String nickname;
  String photoUrl;
  String aboutMe;

  CustomUser({
    required this.id,
    required this.nickname,
    required this.photoUrl,
    required this.aboutMe,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.nickname: nickname,
      Keys.aboutMe: aboutMe,
      Keys.photoUrl: photoUrl,
    };
  }

  factory CustomUser.fromDocument(DocumentSnapshot doc) {
    return CustomUser(
      id: doc.id,
      photoUrl: doc.get(Keys.photoUrl),
      nickname: doc.get(Keys.nickname),
      aboutMe: doc.get(Keys.aboutMe),
    );
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      id: map[Keys.id],
      photoUrl: map[Keys.photoUrl],
      nickname: map[Keys.nickname],
      aboutMe: map[Keys.aboutMe],
    );
  }

  factory CustomUser.fromFirebaseUser(User user) {
    return CustomUser(
      id: user.uid,
      nickname: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
      aboutMe: '',
    );
  }
}
