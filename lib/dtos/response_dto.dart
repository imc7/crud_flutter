class ResponseDTO<T> {
  int _code;
  String _message;
  T _data;

  ResponseDTO(this._code, this._message, this._data);
}
