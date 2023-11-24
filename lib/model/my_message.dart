import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String messageId;
  late String text;
  late String senderId;
  late Timestamp timestamp;

  Message.empty() {
    messageId = "";
    text = "";
    senderId = "";
    timestamp = Timestamp.now();
  }

  Message.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data != null) {
      messageId = snapshot.id;
      text = data['text'] ?? "";
      senderId = data['senderId'] ?? "";
      timestamp = data['timestamp'] ?? Timestamp.now();
    } else {
      messageId = "";
      text = "";
      senderId = "";
      timestamp = Timestamp.now();
    }
  }
}
