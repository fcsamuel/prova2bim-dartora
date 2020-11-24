import 'dart:async';

import 'package:flutter/material.dart';

import 'Home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, "/cadastro");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.all(18),
        child: Center(
          child: Image.asset("images/logoapp.png"),
        ),
      ),
    );
  }
}
