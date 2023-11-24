import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Message {
  late String senderId;
  late String text;

  Message({
    required this.senderId,
    required this.text,
  });

  factory Message.fromSnapshot(dynamic data) {
    return Message(
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
    );
  }
}

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({Key? key, required this.conversationId})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final DatabaseReference messagesRef =
      FirebaseDatabase.instance.ref().child('conversations');

  final TextEditingController _messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: messagesRef
                  .child(widget.conversationId)
                  .child('messages')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData &&
                    snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic>? messagesMap =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                  if (messagesMap == null || messagesMap.isEmpty) {
                    return const Center(child: Text('Aucun message.'));
                  }

                  List<Message> messages = messagesMap.entries
                      .map((entry) => Message.fromSnapshot(entry.value))
                      .toList();

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      return ListTile(
                        title: Text(message.text),
                        trailing: message.senderId == 'ID_de_l_utilisateur'
                            ? const Icon(Icons.arrow_forward,
                                color: Colors.blue)
                            : const Icon(Icons.arrow_back, color: Colors.green),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Aucun message.'));
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageTextController,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez votre message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String messageText = _messageTextController.text.trim();
                    if (messageText.isNotEmpty) {
                      sendMessage(messageText);
                      _messageTextController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String messageText) {
    Message message = Message(
      senderId: 'ID_de_l_utilisateur',
      text: messageText,
    );
    messagesRef
        .child(widget.conversationId)
        .child('messages')
        .push()
        .set({
          'senderId': message.senderId,
          'text': message.text,
        })
        .then((_) {})
        .catchError((error) {});
  }
}
