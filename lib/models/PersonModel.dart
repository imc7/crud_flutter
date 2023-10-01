class PersonModel {
  String _id = '';
  String _name = '';
  int _age = 0;
  String _photoUrl = '';

  PersonModel(this._id, this._name, this._age, this._photoUrl);

  // Getters and setters
  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
