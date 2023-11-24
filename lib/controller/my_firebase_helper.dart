import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:ipssi_flutter/model/my_user.dart';

class MyFirebaseHelper {
  final auth = FirebaseAuth.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");
  final storage = FirebaseStorage.instance;

  Future<MyUser> createUserFirebase({
    required String email,
    required String password,
    required String nom,
    required String prenom,
  }) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String uid = credential.user!.uid;
    Map<String, dynamic> data = {
      "NOM": nom,
      "PRENOM": prenom,
      "EMAIL": email,
    };
    addUser(uid, data);
    return getUser(uid);
  }

  Future<MyUser> connectFirebase({
    required String email,
    required String password,
  }) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    return getUser(uid);
  }

  Future<MyUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return MyUser.fromSnapshot(
        snapshot);
  }

  Future<void> addUser(String uid, Map<String, dynamic> data) async {
    await cloudUsers.doc(uid).set(data);
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> data) {
    return cloudUsers.doc(uid).update(data);
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String imageName,
    required String folder,
    required String uid,
  }) async {
    TaskSnapshot snapshot =
        await storage.ref("$folder/$uid/$imageName").putData(bytes);
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> updateFavorites(String uid, List<String> favoriteUserIds) {
    return cloudUsers.doc(uid).update({'favoris': favoriteUserIds});
  }

  Future<List<String>> getFavorites(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('favoris')) {
        return List<String>.from(userData['favoris']);
      }
    }
    return [];
  }

  Future<void> sendMessage({
    required String messageText,
    required String senderId,
    required String chatId,
  }) async {
    try {
      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);
      final messagesCollection = chatRef.collection('MESSAGES');
      final messagesExist = await messagesCollection.get();

      if (messagesExist.docs.isEmpty) {
        await chatRef.set({'name': 'Conversation Name'});
        await messagesCollection.add({});
      }

      await messagesCollection.add({
        'text': messageText,
        'senderId': senderId,
        'timestamp': DateTime.now(),
        'userId': senderId,
      });
    } catch (error) {
      if (kDebugMode) {
        print('Erreur lors de l\'envoi du message : $error');
      }
    }
  }

  stockageImage({required Uint8List bytes, required String nameImage, required String dossier, required uid}) {}

  void upadteUser(uid, Map<String, dynamic> data) {}
}
