import 'dart:io';

import 'package:crud_flutter/dtos/response_dto.dart';
import 'package:crud_flutter/dtos/UserDTO.dart';
import 'package:crud_flutter/services/firebase_storage_service.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  // Register new user
  Future<ResponseDTO<String>> signUp(UserDTO toSave) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: toSave.email!,
        password: toSave.password!,
      );
      User? user = credential.user;
      return ResponseDTO(Constants.code_success, 'It was good!', "");
    } on FirebaseAuthException catch (e) {
      String message = 'Could not sign up user';
      if (e.code == Constants.authCodeWeakPassword) {
        message = 'The password provided is too weak.';
      } else if (e.code == Constants.authCodeEmailAlreadyInUse) {
        message = 'The account already exists for that email.';
      }
      return ResponseDTO(Constants.code_warning, message, e.code);
    } catch (e) {
      return ResponseDTO(Constants.code_error, 'It was wrong!', "");
    }
  }

  // Get current user
  User? getCurrentUser() {
    User? current = FirebaseAuth.instance.currentUser;
    print("current user: ${current}");
    if (current != null) return current;
    return null;
  }

  // Login user
  Future<ResponseDTO<String>> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return ResponseDTO(Constants.code_success, 'It was good!', "");
    } on FirebaseAuthException catch (e) {
      String message = 'Could not do autentication';
      if (e.code == Constants.userNotFound) {
        message = 'No user found for that email.';
      } else if (e.code == Constants.wrongPassword) {
        message = 'Wrong password provided for that user.';
      } else if (e.code == Constants.invalidLoginCredential) {
        message = 'Invalid login credentials.';
      }
      return ResponseDTO(
          Constants.code_warning, 'Invalid login credentials.', e.code);
    } catch (e) {
      return ResponseDTO(Constants.code_error, 'It was wrong!', "");
    }
  }

  // Sign out
  Future<ResponseDTO<String>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return ResponseDTO(Constants.code_success, 'Sign out successfully', "");
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e}");
      return ResponseDTO(Constants.code_warning, 'Could not sign out', e.code);
    } catch (e) {
      print("FirebaseAuthException catch: ${e}");
      return ResponseDTO(Constants.code_error, 'It was wrong!', "");
    }
  }
}
