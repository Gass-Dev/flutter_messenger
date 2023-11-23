import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/my_firebase_helper.dart';
import '../model/my_user.dart';

class MyAllUsers extends StatefulWidget {
  const MyAllUsers({Key? key});

  @override
  State<MyAllUsers> createState() => _MyAllUsersState();
}
class _MyAllUsersState extends State<MyAllUsers> {
  Map<String, bool> favorites = {};
  late String currentUserUid; // Stocker l'UID de l'utilisateur connecté quand elle sera instancié

  @override
  initState() {
    // 'UID de l'utilisateur connecté
    getCurrentUserUid();
  }

  // Obbtenir l'UID de l'utilisateur connecté
  getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    currentUserUid = user?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: MyFirebaseHelper().cloudUsers.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        } else {
          if (!snap.hasData) {
            return const Center(
              child: Text("Aucune donnée"),
            );
          } else {
            List<DocumentSnapshot> documents = snap.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                MyUser lesAutres = MyUser(documents[index]);
                final isFavorite = favorites.containsKey(lesAutres.uid) ? favorites[lesAutres.uid] : false;

                // Sup l'utilisateur connecté de la liste affichée
                if (lesAutres.uid == currentUserUid) {
                  return const SizedBox();
                }

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(lesAutres.image!),
                    ),
                    title: Text(lesAutres.nom),
                    subtitle: Text(lesAutres.mail),
                    trailing: IconButton(
                      icon: Icon(
                        // Chnage de couleur si on click
                        isFavorite == true ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite == true ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        setState(() {
                          favorites[lesAutres.uid] = !(isFavorite ?? false);
                        });

                        // Mettre à jour la bdd si l'utilisateur a ajouté/retiré des favoris
                        if (favorites[lesAutres.uid] == true) {
                          List<String> updatedFavorites = [];
                          for (var entry in favorites.entries) {
                            if (entry.value == true) {
                              updatedFavorites.add(entry.key);
                            }
                          }

                          await MyFirebaseHelper().updateFavorites(lesAutres.uid, updatedFavorites);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
