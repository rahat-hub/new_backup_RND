import 'dart:developer';

///i = info, w = warning, d = debug, e = error
void showLog({required String message, String? type, Object? errorMessage}) {
  switch (type) {
    case "i":
      log(message, name: "INFO", time: DateTime.now(), level: 1);
    case "d":
      log(message, name: "DEBUG", time: DateTime.now(), level: 2);
    case "w":
      log(message, name: "WARNING", time: DateTime.now(), level: 3);
    case "e":
      log(message, name: "ERROR", time: DateTime.now(), level: 4, error: errorMessage);
    default:
      log(message, name: "INFO", time: DateTime.now());
  }
}
