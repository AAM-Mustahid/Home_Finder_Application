import 'package:flutter/material.dart';
import 'package:home_finder_app/home.dart';
import 'package:home_finder_app/register.dart';
import 'package:home_finder_app/start.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});
  @override
  State<GetStarted> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<GetStarted> {
  var activeScreen = 'start-screen';

  void switchScreen() {
    setState(() {
      activeScreen = 'questions-screen';
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'questions-screen') {
      screenWidget = RegisterPage();
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: screenWidget,
        ),
      ),
    );
  }
}
