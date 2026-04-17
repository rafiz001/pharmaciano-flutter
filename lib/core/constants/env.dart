
class Env {
  static String get apiBaseUrl =>  'https://pharmaciano-backend.vercel.app';
  static String get apiVersion => 'v1';
  static String get jwtSecret =>  'i-am-rafiz';
  static String get appName =>  'Pharmaciano';
  
  static String get loginEndpoint => '$apiBaseUrl/api/$apiVersion/auth/login';
  
  

}
