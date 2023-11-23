import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ipssi_flutter/view/my_dashboard.dart';
import 'package:ipssi_flutter/view/';
import 'controller/my_firebase_helper.dart';
import 'firebase_options.dart';
import 'globale.dart';
import 'mesWidgets/my_animation.dart';
import 'mesWidgets/my_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MyPermissionPhoto().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyLoading(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //variables
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();

  //méthode
  popError() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erreur"),
            content: const Text("email/ou mot de passe erroné"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Stack(
      children: [
        const MyBackground(),
        SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  const SizedBox(height: 40),
                  //image
                  MyAnimation(
                    time: 1,
                    child: Image.network(
                        "data:image/jpeg;base64,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"),
                  ),
                  const SizedBox(height: 40),
                  //champs des mails

                  MyAnimation(
                    time: 2,
                    child: TextField(
                        controller: mail,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: const Icon(Icons.mail),
                            hintText: "Entrer un mail",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                  ),

                  //champs du mot de passe
                  const SizedBox(height: 10),

                  MyAnimation(
                    time: 3,
                    child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: const Icon(Icons.lock),
                            hintText: "Entrer un password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                  ),
                  const SizedBox(height: 10),

                  // bouton
                  MyAnimation(
                    time: 4,
                    child: ElevatedButton(
                        onPressed: () {
                          MyFirebaseHelper()
                              .connectFirebase(
                                  email: mail.text, password: password.text)
                              .then((value) {
                            setState(() {
                              moi = value;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyDashBoard()));
                          }).catchError((onError) {
                            //afficher un pop
                            popError();
                          });
                        },
                        child: const Text("Connexion")),
                  ),

                  MyAnimation(
                    time: 5,
                    child: TextButton(
                        onPressed: () {
                          MyFirebaseHelper()
                              .createUserFirebase(
                                  email: mail.text,
                                  password: password.text,
                                  nom: "",
                                  prenom: "")
                              .then((value) {
                            setState(() {
                              moi = value;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyDashBoard()));
                          });
                        },
                        child: const Text("Inscription")),
                  ),
                ]))),
      ],
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
