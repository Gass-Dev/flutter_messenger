import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ipssi_flutter/globale.dart';

class MyUser {
  late String uid;
  late String mail;
  String? image;
  late String nom;
  late String prenom;
  String? pseudo;
  List? favoris;

  MyUser.empty() {
    uid = "";
    mail = "";
    nom = "";
    prenom = "";
    favoris = [];
  }
  MyUser(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    mail = data["EMAIL"];
    nom = data["NOM"];
    prenom = data["PRENOM"];
    image = data["IMAGE"] ?? imageDefault;
    favoris = data["FAVORIS"] ?? [];
    pseudo = data["PSEUDO"] ?? "";
  }
}

