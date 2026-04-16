// lib/app/login_providers.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pharmaciano/core/constants/env.dart';
import 'package:pharmaciano/views/models/user_model.dart';

final loginCredentialProvider = StateProvider<List<String>>((ref){return [];});

final loginProvider = FutureProvider<UserModel>((ref) async {
  try {
    final loginCredential = ref.watch(loginCredentialProvider);
    if(loginCredential.length!=2) throw "No credentials found!";
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json'; 
    print(loginCredential);
    print("${Env.apiBaseUrl}/api/v1/auth/login");
    final response = await dio.post(
      "${Env.apiBaseUrl}/api/v1/auth/login",
      data: jsonEncode({"email": loginCredential[0], "password": loginCredential[1]}),
    );
    if (response.statusCode == 200) {
      print(response.data);
      final loginData = UserModel.fromJson(response.data);
      return loginData;
    } else {
      print(response.data);
      throw "Something went wrong.";
    }
  } catch (e) {
    rethrow;
  }
});
