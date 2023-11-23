import 'package:flutter/material.dart';
import 'package:ipssi_flutter/main.dart';
import 'package:ipssi_flutter/mesWidgets/my_background.dart';
import 'package:lottie/lottie.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({super.key});

  @override
  State<MyLoading> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MyBackground(),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: PageView(
                  controller: pageController,
                  children: [
                    Lottie.asset("assets/cat_Animation.json"),
                    const MyHomePage(title: "APP Map")
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  child: const Text("Get Started"))
            ],
          ),
        ],
      ),
    );
  }
}
