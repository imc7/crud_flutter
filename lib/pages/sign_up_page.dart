import 'dart:io';

import 'package:crud_flutter/services/select_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase_auth_service.dart';
import '../widgets/text_password_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuthService authService = FirebaseAuthService();

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController ageController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  String photoUrl = "";
  File? image_to_upload = null;
  bool _emailOk = false;
  bool obscureText = true;
  bool obscureTextConfirm = true;

  @override
  void initState() {
    super.initState();

    // Listening
    nameController.addListener(() {
      setState(() {});
    });
    ageController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
    confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // To select image
  void selectImage(ImageSource source) async {
    final XFile? image = await pickImage(source);
    if (image != null) {
      setState(() {
        image_to_upload = File(image!.path);
      });
    }
  }

  // To inactivate/activate save button
  bool shouldActiveSaveButton() {
    return nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        _emailOk;
  }

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

  String? passwordConfirmErrorMessage() {
    String confirmPassword = confirmPasswordController.text;
    if (confirmPassword.isNotEmpty &&
        passwordController.text != passwordController.text)
      return "Password confirm is not the same with passwod";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 20,
                  ),
                  child: Stack(
                    children: [
                      photoUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                photoUrl,
                              ),
                            )
                          : image_to_upload == null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    'assets/images/person.png',
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  backgroundImage: FileImage(
                                    image_to_upload!,
                                  ),
                                ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Center(
                                          child: Text('Select an option')),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              iconSize: 36.0,
                                              onPressed: () {
                                                selectImage(ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.add_a_photo)),
                                          IconButton(
                                              iconSize: 36.0,
                                              onPressed: () {
                                                selectImage(
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.folder))
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            child: Text("Cancel"),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    ));
                          },
                        ),
                        bottom: -15,
                        left: 80,
                      )
                    ],
                  ),
                ),

                // Name
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                // Age
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    controller: ageController,
                    decoration: const InputDecoration(
                      label: Text('Age'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

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

                // Confirm password
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 30,
                    right: 0,
                    bottom: 0,
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureTextConfirm,
                    decoration: InputDecoration(
                        label: Text('Confirm password'),
                        border: OutlineInputBorder(),
                        errorText: passwordConfirmErrorMessage(),
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

                // Control buttons
                Container(
                  margin: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    right: 0,
                    bottom: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(100, 40),
                        ),
                        child: Text("Cancel",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        onPressed: () => {Navigator.pop(context)},
                      ),
                      // Save button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize: Size(100, 40),
                          disabledForegroundColor: Color(0xFFC0C0C0),
                          disabledBackgroundColor: Color(0xFFC4EAF9),
                        ),
                        child: Text("Save",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        onPressed: shouldActiveSaveButton()
                            ? () async {
                                authService.signUp(emailController.text,
                                    passwordController.text);
                              }
                            : null,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
