import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;

// To upload files
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

// To delete files
Future<void> deleteFile(String id) async {
  // Create a reference to the file to delete
  final desertRef = FirebaseStorage.instance.ref().child("images/${id}.jpg");

// Delete the file
  await desertRef.delete();
}
