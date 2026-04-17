// lib/app/login_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/core/constants/env.dart';
import 'package:pharmaciano/models/auth_model.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

// Make AuthModel nullable
class LoginNotifier extends AsyncNotifier<AuthModel?> {
  @override
  Future<AuthModel?> build() async {
    state = const AsyncLoading();
    return null;
  }

  Future<void> login(String email, String password, BuildContext ctx) async {
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
        final userData = AuthModel.fromJson(response.data);
        if(kDebugMode){
        print(userData.toJson());
        }

        if(userData.data!=null && userData.data!.token!=null){
         await FlutterSessionJwt.saveToken(userData.data!.token!);
        }else{
          state = AsyncError("Data malfunctioned", StackTrace.current);
        }
        if(ctx.mounted){
        Navigator.pushReplacementNamed(ctx, "/dashboard");
        }

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

final loginProvider = AsyncNotifierProvider<LoginNotifier, AuthModel?>(() {
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
