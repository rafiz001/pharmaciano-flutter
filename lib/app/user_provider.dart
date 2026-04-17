import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:pharmaciano/core/constants/env.dart';
import 'package:pharmaciano/models/user_model.dart';

class ProfileNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    getProfile();
    return null;
  }

  Future<void> getProfile() async {
    // Set loading state
    state = const AsyncLoading();

    try {
      final savedToken = await FlutterSessionJwt.retrieveToken();
      print(savedToken);
      final dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = savedToken;
      final response = await dio.get(
        Env.profileEndpoint,
        //data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final userData = UserModel.fromJson(response.data);
        if(kDebugMode){
        print(userData.toJson());
        }
        state = AsyncData(userData);
      } else {
        state = AsyncError("Data problem!", StackTrace.current);
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, UserModel?>(() {
  return ProfileNotifier();
});