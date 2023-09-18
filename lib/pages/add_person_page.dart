import 'dart:io';

import 'package:crud_flutter/services/firebase_service.dart';
import 'package:crud_flutter/services/firebase_storage.dart';
import 'package:crud_flutter/services/select_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  String id = "";
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController ageController = TextEditingController(text: "");
  String photoUrl = "";
  File? image_to_upload = null;

  void selectImage(ImageSource source) async {
    final XFile? image = await pickImage(source);
    if (image != null) {
      setState(() {
        image_to_upload = File(image!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        bottom: -10,
                        left: 150,
                      )
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: ageController,
                  decoration: const InputDecoration(hintText: 'Age'),
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
                        MaterialButton(
                          height: 40.0,
                          minWidth: 100.0,
                          color: Colors.red,
                          textColor: Colors.white,
                          child: new Text("Cancel"),
                          onPressed: () => {Navigator.pop(context)},
                          splashColor: Colors.redAccent,
                        ),
                        // Save button
                        MaterialButton(
                          height: 40.0,
                          minWidth: 100.0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: new Text("Save"),
                          onPressed: () async {
                            await save(id, nameController.text,
                                    int.parse(ageController.text))
                                .then((personId) async {
                              if (image_to_upload != null) {
                                String url = await uploadFile(
                                    image_to_upload!, personId);
                                await uploadPhoto(personId, url);
                              }
                              Navigator.pop(context);
                            });
                          },
                          splashColor: Colors.redAccent,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
