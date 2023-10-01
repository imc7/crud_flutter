import 'dart:io';

import 'package:crud_flutter/dtos/response_dto.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

// To upload files
  Future<ResponseDTO<String>> uploadFile(File file, String id) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to 'images/fileName.jpg'
    final mountainImagesRef = storageRef.child("images/${id}.jpg");

    try {
      await mountainImagesRef.putFile(file);
      String photoURL = await mountainImagesRef.getDownloadURL();
      return ResponseDTO(Constants.code_success, "It was good!", photoURL);
    } on FirebaseException catch (e) {
      return ResponseDTO(
          Constants.code_warning, "Could not upload file", e.code);
    }
  }

// To delete files
  Future<void> deleteFile(String id) async {
    // Create a reference to the file to delete
    final desertRef = FirebaseStorage.instance.ref().child("images/${id}.jpg");

// Delete the file
    await desertRef.delete();
  }
}
