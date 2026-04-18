import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:pharmaciano/core/constants/env.dart';
import 'package:pharmaciano/models/batch_model.dart';
import 'package:pharmaciano/models/medicine_model.dart';

final batchesProvider = FutureProvider.autoDispose<List<BatchModel>>((
  ref,
) async {
  List<BatchModel> result = [];
  try {
    final savedToken = await FlutterSessionJwt.retrieveToken();
    print(savedToken);
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $savedToken';
    final response = await dio.get(Env.getInventoryBatchesEndpoint);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.data);
      }
      List<dynamic> allRaw = response.data["data"];
      allRaw.forEach((item) {
        final single = BatchModel.fromJson(item);
        result.add(single);
      });
      if (kDebugMode) {
        print("Total Batches: ${result.length}");
      }
      return result;
    } else {
      throw "Connection Problem.";
    }
  } catch (e) {
    rethrow;
  }
});

final searchProvider =
    AsyncNotifierProvider<SearchNotifier, List<MedicineModel>?>(
      () => SearchNotifier(),
    );

class SearchNotifier extends AsyncNotifier<List<MedicineModel>?> {
  @override
  Future<List<MedicineModel>?> build() async {
    return null;
  }

  Future<void> getSearchResult(String query) async {
    state = const AsyncLoading();

    List<MedicineModel> result = [];
    try {
      final savedToken = await FlutterSessionJwt.retrieveToken();
      print(savedToken);
      final dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $savedToken';
      final response = await dio.get(Env.getAllMedicinesEndpoint,queryParameters: {"search":query});

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        List<dynamic> allRaw = response.data["data"]["medicine"];
        allRaw.forEach((item) {
          final single = MedicineModel.fromJson(item);
          result.add(single);
        });
        if (kDebugMode) {
          print("Total Medicines: ${result.length}");
        }
        state = AsyncData(result);
      } else {
        throw "Connection Problem.";
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
    void reset() {
    state = const AsyncData(null);
  }
}
