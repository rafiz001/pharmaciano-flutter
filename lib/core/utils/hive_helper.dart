import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String _authBoxName = 'auth_box';
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    // No adapters to register - we store primitive types and Maps
  }
  
  static Future<Box> _openAuthBox() async {
    return await Hive.openBox(_authBoxName);
  }
  
  // === TOKEN OPERATIONS ===
  static Future<void> saveToken(String token) async {
    final box = await _openAuthBox();
    await box.put(_tokenKey, token);
  }
  
  static String? getToken() {
    if (!Hive.isBoxOpen(_authBoxName)) return null;
    final box = Hive.box(_authBoxName);
    return box.get(_tokenKey) as String?;
  }
  
  static Future<void> clearToken() async {
    if (!Hive.isBoxOpen(_authBoxName)) return;
    final box = Hive.box(_authBoxName);
    await box.delete(_tokenKey);
  }
  
  // === USER OPERATIONS ===
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final box = await _openAuthBox();
    await box.put(_userKey, userData);
  }
  
  static Map<String, dynamic>? getUser() {
    if (!Hive.isBoxOpen(_authBoxName)) return null;
    final box = Hive.box(_authBoxName);
    final data = box.get(_userKey);
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }
  
  static Future<void> clearAuth() async {
    if (!Hive.isBoxOpen(_authBoxName)) return;
    final box = Hive.box(_authBoxName);
    await box.delete(_tokenKey);
    await box.delete(_userKey);
  }
  
  static bool get isAuthenticated => getToken() != null;
}
