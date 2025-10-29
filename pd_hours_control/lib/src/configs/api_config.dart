import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Detecta automaticamente o ambiente e define o baseUrl
class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Rodando no navegador (Flutter Web)
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      // Rodando no Android Emulator
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      // iOS Simulator
      return 'http://127.0.0.1:3000';
    } else {
      // Windows, macOS, Linux
      return 'http://localhost:3000';
    }
  }
}
