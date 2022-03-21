import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/constants/keys.dart';

class UserChat {
  String id;
  String photoUrl;
  String nickname;
  String aboutMe;

  UserChat({
    required this.id,
    required this.photoUrl,
    required this.nickname,
    required this.aboutMe,
  });

  Map<String, String> toJson() {
    return {
      Keys.nickname: nickname,
      Keys.aboutMe: aboutMe,
      Keys.photoUrl: photoUrl,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    return UserChat(
      id: doc.id,
      photoUrl: doc.get(Keys.photoUrl),
      nickname: doc.get(Keys.nickname),
      aboutMe: doc.get(Keys.aboutMe),
    );
  }
}
