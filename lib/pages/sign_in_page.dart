import 'package:crud_flutter/pages/sign_up_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FirebaseAuthService authService = FirebaseAuthService();

  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool remenberSwitch = true;
  bool obscureText = true;

  // Error validators
  String? emailErrorMessage() {
    String email = emailController.text;
    if (email.isNotEmpty && !EmailValidator.validate(email))
      return "It is not a email";
    return null;
  }

  String? passwordErrorMessage() {
    String password = passwordController.text;
    if (password.isNotEmpty && password.length < 7)
      return "Length it is not the minimum";
    return null;
  }

  // To inactivate/activate save button
  bool shouldActiveSaveButton() {
    String email = emailController.text;
    String password = passwordController.text;
    return email.isNotEmpty &&
        EmailValidator.validate(email) &&
        password.isNotEmpty &&
        password.length >= 7;
  }

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
                // Form //////////////////////////////////////////////

                // Email
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Text('Email'),
                      border: OutlineInputBorder(),
                      errorText: emailErrorMessage(),
                    ),
                  ),
                ),

                // Password
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                        label: Text('Password'),
                        border: OutlineInputBorder(),
                        errorText: passwordErrorMessage(),
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0XFF4FBF26)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: obscureText
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Color(0XFF4FBF26),
                                ),
                        )),
                  ),
                ),

                // Remenber toggle
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  width: double.infinity,
                  child: SwitchListTile(
                    title: const Text("Remember me?"),
                    value: remenberSwitch,
                    onChanged: (bool value) {
                      setState(() {
                        remenberSwitch = value;
                      });
                    },
                    activeColor: Colors.green.shade400,
                  ),
                ),

                // Send button
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

                // Sign up button
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
