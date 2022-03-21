import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/message_type.dart';

class Message {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  MessageType type;

  Message({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.idFrom: idFrom,
      Keys.idTo: idTo,
      Keys.timestamp: timestamp,
      Keys.content: content,
      Keys.type: type,
    };
  }

  // TODO: replace DocumentSnapshot with Map<String, dynamic>
  factory Message.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(Keys.idFrom);
    String idTo = doc.get(Keys.idTo);
    String timestamp = doc.get(Keys.timestamp);
    String content = doc.get(Keys.content);
    // TODO: check how saved in firestore
    MessageType type = doc.get(Keys.type);

    return Message(
      idFrom: idFrom,
      idTo: idTo,
      timestamp: timestamp,
      content: content,
      type: type,
    );
  }
}
