import 'package:flutter/material.dart';
import 'package:ipssi_flutter/main.dart';
import 'package:ipssi_flutter/mesWidgets/my_background.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class MyLoading extends StatefulWidget {
  const MyLoading({Key? key});

  @override
  State<MyLoading> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "APP Map"),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MyBackground(),
          Center(
            child: Container(
              color: const Color(0xFFe6fe4f),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Lottie.asset("assets/monster.json"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome to my app.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
