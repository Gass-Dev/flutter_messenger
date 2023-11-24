import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late String userId;
  late String nom;
  late String prenom;
  late String email;
  late String pseudo;
  late String image;

  MyUser.empty();

  MyUser({
    required this.userId,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.pseudo,
    required this.image,
  });

  factory MyUser.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return MyUser(
      userId: snapshot.id,
      nom: data['NOM'] ?? '',
      prenom: data['PRENOM'] ?? '',
      email: data['EMAIL'] ?? '',
      pseudo: data['PSEUDO'] ?? '',
      image: data['IMAGE'] ?? '',
    );
  }

  String get uid => userId;

  setPseudo(String newPseudo) {
    pseudo = newPseudo;
  }

  setImage(String newImage) {
    image = newImage;
  }
}
