import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/models/message_type.dart';

class Message {
  String idFrom;
  String idTo;
  DateTime timestamp;
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
      Keys.timestamp: timestamp.millisecondsSinceEpoch.toString(),
      Keys.content: content,
      Keys.type: type.name,
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    final type = doc.get(Keys.type) == 'text'
        ? MessageType.text
        : doc.get(Keys.type) == 'image'
            ? MessageType.image
            : throw Exception();

    return Message(
      idFrom: doc.get(Keys.idFrom),
      idTo: doc.get(Keys.idTo),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          int.parse(doc.get(Keys.timestamp))),
      content: doc.get(Keys.content),
      type: type,
    );
  }
}
