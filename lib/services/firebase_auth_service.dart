import 'package:crud_flutter/dtos/response_dto.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  // Register new user
  Future<ResponseDTO<String>> signUp(
      String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
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
}
