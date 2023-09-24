import 'package:crud_flutter/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      await getDataFromPreferences()
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        title: '',
                      )))
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignInPage()));
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

  // Get data from preferences
  Future<bool> getDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the email and password key. If it doesn't exist, return ''.
    final email = prefs.getInt('email') ?? '';
    final password = prefs.getInt('password') ?? '';

    return false;
  }
}
