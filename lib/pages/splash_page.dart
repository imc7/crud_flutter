import 'package:crud_flutter/pages/sign_in_page.dart';
import 'package:crud_flutter/tools/preferences_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dtos/response_dto.dart';
import '../main.dart';
import '../services/firebase_auth_service.dart';
import '../tools/Constants.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // Main
  FirebaseAuthService authService = FirebaseAuthService();
  // Others
  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // Hide keyboard
    // Get data from preferencces
    initializeEmailAndPassword();
    // Navigate
    navigate_to_home();
  }

  // Initialize email and password from SharedPreferences data
  initializeEmailAndPassword() async {
    SharedPreferences prefs = await getFromPreferences();
    email = prefs.getString('email') ?? '';
    password = prefs.getString('password') ?? '';
  }

  // Log in
  tryLogIn() async {
    ResponseDTO<String> response = await authService.signIn(email, password);
    if (response.code == Constants.code_success) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: '',
                  )));
    }
  }

  navigate_to_home() async {
    await Future.delayed(Duration(seconds: 2), () async {
      await email.isNotEmpty && password.isNotEmpty
          ? tryLogIn()
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
}
