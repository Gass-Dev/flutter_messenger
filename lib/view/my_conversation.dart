import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/my_message.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({Key? key, required this.conversationId}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'text': _messageController.text,
        'senderId': 'YOUR_SENDER_ID',
        'senderAvatar': 'URL_DE_TON_AVATAR',
        'timestamp': Timestamp.now(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messagerie'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: MessageList(),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Écrire un message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement des messages'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Message> messages = snapshot.data!.docs.map((doc) {
          return Message.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  Widget buildMessageItem(Message message) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(message.senderAvatar),
      ),
      title: Text(message.text),
      subtitle: Text(message.senderId),
      trailing: Text(message.timestamp.toString()),
    );
  }
}
