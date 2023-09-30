class ResponseDTO<T> {
  int _code;
  String _message;
  T _data;

  // Constructors
  ResponseDTO(this._code, this._message, this._data);

  // Getters and setters

  T get data => _data;

  set data(T value) {
    _data = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  int get code => _code;

  set code(int value) {
    _code = value;
  }
}
