import 'dart:io';

class UserDTO {
  String? _uid;
  String? _displayName;
  int? _age;
  String? _email;
  String? _password;
  File? _photoFile;

  UserDTO(
    this._uid,
    this._displayName,
    this._age,
    this._email,
    this._password,
    this._photoFile,
  );

  // Getters and setters

  File? get photoFile => _photoFile;

  set photoFile(File? value) {
    _photoFile = value;
  }

  String? get password => _password;

  set password(String? value) {
    _password = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  int? get age => _age;

  set age(int? value) {
    _age = value;
  }

  String? get displayName => _displayName;

  set displayName(String? value) {
    _displayName = value;
  }

  String? get uid => _uid;

  set uid(String? value) {
    _uid = value;
  }
}
