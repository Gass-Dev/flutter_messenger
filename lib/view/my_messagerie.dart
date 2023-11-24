import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationMessagesScreen extends StatelessWidget {
  final String conversationId;

  const ConversationMessagesScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages de la conversation'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(conversationId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Aucun message dans cette conversation.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot message = snapshot.data!.docs[index];
              return ListTile(
                title: Text(message['text']),
                subtitle: Text(message['senderId']),
              );
            },
          );
        },
      ),
    );
  }
}
