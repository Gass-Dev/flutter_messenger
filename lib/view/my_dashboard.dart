import 'package:flutter/material.dart';
import 'package:ipssi_flutter/mesWidgets/my_background.dart';
import 'package:ipssi_flutter/mesWidgets/my_profil.dart';
import 'package:ipssi_flutter/view/my_all_conversations.dart';
import 'package:ipssi_flutter/view/my_all_users.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({Key? key}) : super(key: key);

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  int indexTapped = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: const MyProfil(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: indexTapped,
        onTap: (value) {
          setState(() {
            indexTapped = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.white),
            label: "Messagerie",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: "Contacts",
          ),
        ],
        selectedItemColor: const Color(0xFFe6fe4f),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const MyBackground(),
          bodyPage(),
        ],
      ),
    );
  }

  Widget bodyPage() {
    switch (indexTapped) {
      case 0:
        return const MessageList(MessageListView: '', messageListView: '',);
      case 1:
        return const MyAllUsers();
      default:
        return const Text("erreur");
    }
  }
}
