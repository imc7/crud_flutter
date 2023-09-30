import 'package:crud_flutter/pages/sign_up_page.dart';
import 'package:crud_flutter/tools/preferences_tools.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dtos/response_dto.dart';
import '../main.dart';
import '../services/alerts.dart';
import '../services/firebase_auth_service.dart';
import '../tools/Constants.dart';

class SignInPage extends StatefulWidget {
  final String? email;
  final String? password;

  const SignInPage({super.key, this.email, this.password});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Main
  FirebaseAuthService authService = FirebaseAuthService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Controllers
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  // Others
  bool remenberSwitch = false;
  bool obscureText = true;

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

    // Passing parameters
    emailController.text = widget.email ?? "";
    passwordController.text = widget.password ?? "";
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
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Email
                      Container(
                        margin: EdgeInsets.only(
                          left: 0,
                          top: 20,
                          right: 0,
                          bottom: 0,
                        ),
                        child: TextFormField(
                          controller: emailController,
                          validator: (String? value) {
                            if (value!.isEmpty) return "Required";
                            if (value!.isNotEmpty &&
                                !EmailValidator.validate(value))
                              return "It is not an email";
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: Text('Email'),
                            border: OutlineInputBorder(),
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
                        child: TextFormField(
                          controller: passwordController,
                          validator: (String? value) {
                            if (value!.isEmpty) return "Required";
                            if (value!.isNotEmpty && value.length < 7)
                              return "Minimum seven characters";
                          },
                          obscureText: obscureText,
                          decoration: InputDecoration(
                              label: Text('Password'),
                              border: OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0XFF4FBF26)),
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

                      // Remember toggle
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

                      // Sign in button
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
                          child: Text("Log in",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onPressed: formKey != null &&
                                  formKey.currentState != null &&
                                  formKey.currentState!.validate() != null &&
                                  formKey.currentState!.validate()
                              ? () async {
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  showLoadingAlert(
                                      context, 'Getting sign in user...');
                                  ResponseDTO<String> response =
                                      await authService.signIn(email, password);
                                  hideLoadingAlert();

                                  int code = response.code;
                                  String message = response.message;
                                  if (code == Constants.code_warning ||
                                      code == Constants.code_error) {
                                    successOrWarningOrErrorAlert(
                                        context, code, message, () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    });
                                  } else if (code == Constants.code_success) {
                                    removePreferences(); // First remove data in Preferences
                                    if (remenberSwitch) {
                                      saveIntoPreferences(email,
                                          password); // Second save data into Preferences
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyHomePage(
                                                  title: '',
                                                )));
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
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
