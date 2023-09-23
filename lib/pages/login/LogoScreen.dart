import 'dart:async';
import'package:examen_dam_info_debarsywilliamchapelierbasile/styles/style.dart';
import 'package:flutter/material.dart';
import '../login/LoginPage.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<LogoScreen>{
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    Duration duration = const Duration(seconds: 1);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const LoginPage()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("images/bank.png"),
            ),
          ],
        ),
      ),
    );
  }
}