import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/providers/chat_provider.dart';

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  TypeMessage type;

  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      Keys.idFrom: idFrom,
      Keys.idTo: idTo,
      Keys.timestamp: timestamp,
      Keys.content: content,
      Keys.type: type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(Keys.idFrom);
    String idTo = doc.get(Keys.idTo);
    String timestamp = doc.get(Keys.timestamp);
    String content = doc.get(Keys.content);
    TypeMessage type = doc.get(Keys.type);
    return MessageChat(
      idFrom: idFrom,
      idTo: idTo,
      timestamp: timestamp,
      content: content,
      type: type,
    );
  }
}
