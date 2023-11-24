import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ipssi_flutter/view/my_conversation.dart';
import '../controller/my_firebase_helper.dart';
import '../model/my_user.dart';

class MyAllUsers extends StatefulWidget {
  const MyAllUsers({Key? key}) : super(key: key);

  @override
  State<MyAllUsers> createState() => _MyAllUsersState();
}

class _MyAllUsersState extends State<MyAllUsers> {
  Map<String, bool> favorites = {};
  late String currentUserUid;

  @override
  void initState() {
    super.initState();
    getCurrentUserUid();
  }

  void getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    currentUserUid = user?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFe6fe4f),
        title: const Text('All Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: MyFirebaseHelper().cloudUsers.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            if (!snap.hasData) {
              return const Center(child: Text("Aucune donnée"));
            } else {
              List<DocumentSnapshot> documents = snap.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  MyUser lesAutres = MyUser.fromSnapshot(documents[index]);
                  final isFavorite = favorites.containsKey(lesAutres.uid)
                      ? favorites[lesAutres.uid]
                      : false;
                  if (lesAutres.uid == currentUserUid) {
                    return const SizedBox();
                  }
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.black),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(lesAutres.image),
                      ),
                      title: Text(
                        lesAutres.nom,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        lesAutres.email,
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite == true ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              setState(() {
                                favorites[lesAutres.uid] = !(isFavorite ?? false);
                              });

                              if (favorites[lesAutres.uid] == true) {
                                List<String> updatedFavorites = [];
                                for (var entry in favorites.entries) {
                                  if (entry.value == true) {
                                    updatedFavorites.add(entry.key);
                                  }
                                }
                                await MyFirebaseHelper()
                                    .updateFavorites(lesAutres.uid, updatedFavorites);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConversationScreen(conversationId: '',),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
