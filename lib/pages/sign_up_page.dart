import 'dart:io';

import 'package:crud_flutter/dtos/response_dto.dart';
import 'package:crud_flutter/dtos/UserDTO.dart';
import 'package:crud_flutter/pages/sign_in_page.dart';
import 'package:crud_flutter/services/alerts_service.dart';
import 'package:crud_flutter/services/select_image.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase_auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Main
  FirebaseAuthService authService = FirebaseAuthService();
  AlertService alertService = AlertService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Controllers
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController ageController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController passwordConfirmController =
      TextEditingController(text: "");
  // Others
  String photoUrl = "";
  File? image_to_upload = null;
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
    passwordConfirmController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Image
                  Container(
                    margin: EdgeInsets.only(
                      left: 0,
                      top: 10,
                      right: 0,
                      bottom: 10,
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
                            icon:
                                Icon(Icons.add_a_photo, color: Colors.black54),
                            onPressed: () async {
                              ImageSource? answer =
                                  await alertService.pickImageAlert(context);
                              if (answer != null) selectImage(answer);
                            },
                          ),
                          bottom: -10,
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
                    child: TextFormField(
                      controller: nameController,
                      validator: (String? value) {
                        if (value!.isEmpty) return "Required";
                        if (value!.isNotEmpty && value!.length < 2)
                          return "Minimum two characters";
                      },
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
                    child: TextFormField(
                      controller: ageController,
                      validator: (String? value) {
                        if (value!.isEmpty) return "Required";
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
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
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.black54),
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
                                    color: Colors.black54,
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
                    child: TextFormField(
                      controller: passwordConfirmController,
                      validator: (String? value) {
                        if (value!.isEmpty) return "Required";
                        if (value!.isNotEmpty &&
                            value != passwordController.text)
                          return "Confirm password is diferent that password";
                      },
                      obscureText: obscureTextConfirm,
                      decoration: InputDecoration(
                          label: Text('Confirm password'),
                          border: OutlineInputBorder(),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.black54),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureTextConfirm = !obscureTextConfirm;
                              });
                            },
                            child: obscureTextConfirm
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.black54,
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
                          onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (contextOther) => SignInPage()))
                          },
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
                          onPressed: formKey != null &&
                                  formKey.currentState != null &&
                                  formKey.currentState!.validate() != null &&
                                  formKey.currentState!.validate()
                              ? () async {
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  alertService.showLoadingAlert(
                                      context, 'Getting sign up user...');

                                  UserDTO toSave = UserDTO(
                                      null,
                                      nameController.text,
                                      null,
                                      email,
                                      password,
                                      image_to_upload);
                                  ResponseDTO<String> response =
                                      await authService.signUp(toSave);
                                  alertService.hideLoadingAlert();

                                  int code = response.code;
                                  String message = response.message;
                                  if (code == Constants.code_warning ||
                                      code == Constants.code_error) {
                                    alertService.successOrWarningOrErrorAlert(
                                        context, code, message, () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    });
                                  } else if (code == Constants.code_success) {
                                    alertService.successOrWarningOrErrorAlert(
                                        context,
                                        code,
                                        'User registered successfully👌', () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (contextOther) =>
                                                  SignInPage(
                                                    email: email,
                                                    password: password,
                                                  )));
                                    });
                                  }
                                }
                              : null,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
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
}
