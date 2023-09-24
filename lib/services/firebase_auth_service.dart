import 'package:crud_flutter/dtos/response_dto.dart';
import 'package:crud_flutter/tools/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  Future<ResponseDTO> signUp(String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == Constants.authCodeWeakPassword) {
        return ResponseDTO(1, 'The password provided is too weak.', e.code);
      } else if (e.code == Constants.authCodeEmailAlreadyInUse) {
        return ResponseDTO(
            1, 'The account already exists for that email.', e.code);
      }
    } catch (e) {
      return ResponseDTO(1, 'It was wrong!', e);
    }
    return ResponseDTO(0, 'It was good!', true);
  }
}
