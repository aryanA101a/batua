enum AppEType { somethingElse, empty, importAccount }

class AppException {
  AppException(this.eType) : _message = _setMessage(eType);
  String _message;
  String get message => _message;

  AppEType eType;

  static String _setMessage(AppEType eType) {
    switch (eType) {
      case AppEType.empty:
        return "Empty";
      case AppEType.somethingElse:
        return "Something went wrong!";
      case AppEType.importAccount:
        return "Cannot import account!";
    }
  }
}
