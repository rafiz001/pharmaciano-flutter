import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';
  static String get jwtSecret => dotenv.env['JWT_SECRET'] ?? '';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Pharmaciano';
  
  static String get loginEndpoint => '$apiBaseUrl/api/$apiVersion/auth/login';
  
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
