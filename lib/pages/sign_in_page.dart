import 'dart:io';

import 'package:crud_flutter/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/text_password_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FirebaseAuthService authService = FirebaseAuthService();

  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();

    // Listening
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // To inactivate/activate save button
  bool shouldActiveSaveButton() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  child: TextField(
                    controller: emailController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  child: TextPasswordField(controller: passwordController),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: Size(100, 40),
                      disabledForegroundColor: Color(0xFFC0C0C0),
                      disabledBackgroundColor: Color(0xFFC4EAF9),
                    ),
                    child: Text("Send",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: shouldActiveSaveButton()
                        ? () async {
                            authService.signUp('2', 'y');
                          }
                        : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: Size(100, 40),
                      disabledForegroundColor: Color(0xFFC0C0C0),
                      disabledBackgroundColor: Color(0xFFC4EAF9),
                    ),
                    child: Text("Sign up",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
