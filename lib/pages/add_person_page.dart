import 'dart:io';

import 'package:crud_flutter/models/PersonModel.dart';
import 'package:crud_flutter/services/alerts_service.dart';
import 'package:crud_flutter/services/firebase_firestore_service.dart';
import 'package:crud_flutter/services/firebase_storage_service.dart';
import 'package:crud_flutter/services/select_image.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../dtos/response_dto.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  AlertService alertService = AlertService();
  String id = "";
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController ageController = TextEditingController(text: "");
  String photoUrl = "";
  File? image_to_upload = null;

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
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
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
    return nameController.text.isNotEmpty && ageController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseStorageService firebaseStorageService =
        FirebaseStorageService();
    // Get arguments from route
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String title = arguments['title'] ?? '--';
    if (arguments['person'] != null) {
      id = arguments['person']['id'];
      nameController.text = arguments['person']['name'];
      ageController.text = arguments['person']['age'].toString();
      photoUrl = arguments['person']['photoUrl'];
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
                    bottom: 20,
                  ),
                  child: Stack(
                    children: [
                      photoUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                photoUrl,
                              ),
                            )
                          : image_to_upload == null
                              ? CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    'assets/images/person.png',
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.white,
                                  backgroundImage: FileImage(
                                    image_to_upload!,
                                  ),
                                ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () async {
                            ImageSource? answer =
                                await alertService.pickImageAlert(context);
                            if (answer != null) {
                              selectImage(answer);
                            }
                          },
                        ),
                        bottom: -10,
                        left: 150,
                      )
                    ],
                  ),
                ),
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
                                setState(() {});
                                PersonModel person = PersonModel(
                                  id,
                                  nameController.text,
                                  int.parse(ageController.text),
                                  photoUrl,
                                );
                                alertService.showLoadingAlert(context, null);
                                await save(person).then((personId) async {
                                  if (image_to_upload != null) {
                                    ResponseDTO<String> response =
                                        await firebaseStorageService.uploadFile(
                                            image_to_upload!, personId);

                                    int code = response.code;
                                    if (code == Constants.code_warning ||
                                        code == Constants.code_error) {
                                      alertService.successOrWarningOrErrorAlert(
                                          context,
                                          code,
                                          response.message,
                                          null);
                                    } else if (code == Constants.code_success) {
                                      await updatePhotoUrl(
                                          personId, response.data);
                                    }
                                  }
                                  alertService.hideLoadingAlert();
                                  Navigator.pop(context);
                                });
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
