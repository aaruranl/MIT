// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practise/Screens/Home/Home.dart';
import 'package:practise/Screens/SplashScreen/OnboardingFirst.dart';

class LogoSplashScreen extends StatelessWidget {
  const LogoSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 10),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Onbording())));
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('assets/png/logoSplash.png'),
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          // child: Container(
          //   width: screenWidth * 0.4,
          //   height: screenHeight * 0.4,
          //   child: Image.asset(
          //     "assets/png/aaru.png",
          //   ),
          // ),
        ),
      ),
    );
  }
}
