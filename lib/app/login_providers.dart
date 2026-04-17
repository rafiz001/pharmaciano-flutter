// lib/app/login_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/core/constants/env.dart';
import 'package:pharmaciano/views/models/user_model.dart';

// Make UserModel nullable
class LoginNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    state = const AsyncLoading();
    return null;
  }

  Future<void> login(String email, String password) async {
    // Set loading state
    state = const AsyncLoading();

    try {
      final dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        Env.loginEndpoint,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final userData = UserModel.fromJson(response.data);
        print(userData.toJson());
        state = AsyncData(userData);
      } else {
        state = AsyncError("Login failed", StackTrace.current);
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final loginProvider = AsyncNotifierProvider<LoginNotifier, UserModel?>(() {
  return LoginNotifier();
});

final passVisibleProvider = NotifierProvider<PassVisibleNotifier, bool>(
  PassVisibleNotifier.new,
);

class PassVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}
