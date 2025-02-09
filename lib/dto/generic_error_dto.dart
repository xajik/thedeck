/*
 *
 *  *
 *  * Created on 13 2 2023
 *
 */

class GenericError {
  final String message;
  final int code;

  GenericError(this.message, this.code);

  GenericError.message(this.message) : code = _Constants.noneCode;

  bool isValid() =>
      this == none ||
      (message != _Constants.noneMessage && code != _Constants.noneCode);

  static final none = GenericError(_Constants.noneMessage, _Constants.noneCode);
}

mixin _Constants {
  static const String noneMessage = "";
  static const int noneCode = -1;
}
