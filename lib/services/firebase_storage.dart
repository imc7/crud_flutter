import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;

Future<String> uploadFile(File file, String id) async {
  // Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

// Create a reference to 'images/mountains.jpg'
  final mountainImagesRef = storageRef.child("images/${id}.jpg");

  try {
    await mountainImagesRef.putFile(file);
  } on FirebaseException catch (e) {
    print("Could't upload file");
  }

  return await mountainImagesRef.getDownloadURL();
}
