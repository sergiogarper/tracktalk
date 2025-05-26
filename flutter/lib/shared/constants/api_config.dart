import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // Para Chrome
    } else {
      return 'http://10.0.2.2:3000'; // Para emulador Android // 'http://192.168.0.3:3000' para apk en MI DISPOSITIVO
    }
  }
}
