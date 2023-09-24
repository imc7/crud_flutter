import 'package:flutter/material.dart';

import '../main.dart';
import 'home_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigate_to_home();
  }

  navigate_to_home() async {
    await Future.delayed(Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: '',
                  )));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF3D9AE3),
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            child: Image.asset("assets/images/icon.png"),
          ),
        ));
  }
}
