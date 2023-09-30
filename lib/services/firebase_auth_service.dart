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
      if (e.code == Constants.authCodeWeakPassword) {
        return ResponseDTO(Constants.code_warning,
            'The password provided is too weak.', e.code);
      } else if (e.code == Constants.authCodeEmailAlreadyInUse) {
        return ResponseDTO(Constants.code_warning,
            'The account already exists for that email.', e.code);
      }
    } catch (e) {
      print("Could not sign up user: ${e}");
      return ResponseDTO(Constants.code_error, 'It was wrong!', "");
    }
    return ResponseDTO(Constants.code_error, 'It was wrong!', "");
  }

  // Login user
  Future<ResponseDTO<String>> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return ResponseDTO(Constants.code_success, 'It was good!', "");
    } on FirebaseAuthException catch (e) {
      if (e.code == Constants.userNotFound) {
        return ResponseDTO(
            Constants.code_warning, 'No user found for that email.', e.code);
      } else if (e.code == 'wrong-password') {
        return ResponseDTO(Constants.code_warning,
            'Wrong password provided for that user.', e.code);
      }
    }
    return ResponseDTO(Constants.code_error, 'It was wrong!', "");
  }
}
