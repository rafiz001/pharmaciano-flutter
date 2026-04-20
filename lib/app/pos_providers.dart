import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:pharmaciano/core/constants/env.dart';
import 'package:pharmaciano/models/batch_model.dart';
import 'package:pharmaciano/models/cart_model.dart';
import 'package:pharmaciano/models/medicine_model.dart';

final batchesProvider = FutureProvider.autoDispose<List<BatchModel>>((
  ref,
) async {
  List<BatchModel> result = [];
  try {
    final savedToken = await FlutterSessionJwt.retrieveToken();
    if (kDebugMode) {
      print(savedToken);
    }
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

Future<List<MedicineModel>> getSearchResult(String query) async {
  try {
    final savedToken = await FlutterSessionJwt.retrieveToken();
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $savedToken';
    final response = await dio.get(
      Env.getAllMedicinesEndpoint,
      queryParameters: {"search": query},
    );
    if (response.statusCode == 200) {
      List<dynamic> allRaw = response.data["data"]["medicine"];
      return allRaw.map((item) => MedicineModel.fromJson(item)).toList();
    }
    return [];
  } catch (e, s) {
    if (kDebugMode) {
      print(s);
    }

    return [];
  }
}

class CartsNotifier extends Notifier<List<CartModel>> {
  @override
  List<CartModel> build() {
    return [];
  }

  void addCart(CartModel newCart) {
    try {
      if (state.isEmpty) {
        state = [newCart];
      } else {
        bool found = false;
        final List<CartModel> result = [];
        for (final cart in state) {
          if (cart.batchNo == newCart.batchNo) {
            result.add(cart.copyWith(quantity: cart.quantity + 1));
            found = true;
          } else {
            print("i am uniq");
            result.add(cart);
          }
        }
        if (!found) {
          result.add(newCart);
        }
        state = result;
      }
      print(state.length);
    } catch (e, s) {
      print(e);
      print(s);
    }

    // print(state);
  }

  void removeCart(String batchNo) {
    state = [
      for (final batch in state)
        if (batch.batchNo != batchNo) batch,
    ];
  }

  void quantity(String batchNo, int newQuantity) {
    if (newQuantity == 0) {
      removeCart(batchNo);
      return;
    }
    state = [
      for (final cart in state)
        if (cart.batchNo == batchNo)
          cart.copyWith(quantity: newQuantity)
        else
          cart,
    ];
  }
}

final cartsProvider = NotifierProvider<CartsNotifier, List<CartModel>>(() {
  return CartsNotifier();
});

class SaleCompleteNotifier extends AsyncNotifier<bool?> {
  @override
  Future<bool?> build() async {
    state = const AsyncLoading();
    return null;
  }

  Future<void> makeSale(
    List<Map<String, dynamic>> carts,
    String customer,
    String customerPhone,
    double discount,
    BuildContext cntx,
  ) async {
    // Set loading state
    state = const AsyncLoading();

    try {
      final savedToken = await FlutterSessionJwt.retrieveToken();
      final dio = Dio();
      //dio.options.validateStatus((int status) { return status < 500; });
      dio.options.headers['Authorization'] = 'Bearer $savedToken';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        Env.createSaleEndpoint,
        data: {
          "customerName": customer,
          "customerPhone": customerPhone,
          "discount": discount,
          "tax": 0,
          "paymentMethod": "cash",
          "items": carts,
        },
      );

      if (response.statusCode! < 300) {
        if (kDebugMode) {
          print(response.data);
        }
        // print()
        final id = response.data["id"];
        final invoiceNo = response.data["invoiceNo"];
        print(id);
        print(invoiceNo);
        String? location = "";
        if (Platform.isAndroid ||
            Platform.isIOS ||
            Platform.isMacOS ||
            Platform.isWindows) {
          location = await FileSaver.instance.saveAs(
            name: invoiceNo,
            link: LinkDetails(
              link: Env.getSalesPdfEndpoint.replaceAll("{id}", id),
              headers: {
                "Authorization": "Bearer $savedToken",
                "Content-Type": "application/json",
              },
              method: "GET",
            ),
            fileExtension: "pdf",
            mimeType: MimeType.pdf,
          );
        } else {
          location = await FileSaver.instance.saveFile(
            name: invoiceNo,
            link: LinkDetails(
              link: Env.getSalesPdfEndpoint.replaceAll("{id}", id),
              headers: {
                "Authorization": "Bearer $savedToken",
                "Content-Type": "application/json",
              },
              method: "GET",
            ),
            fileExtension: "pdf",
            mimeType: MimeType.pdf,
          );
        }
        print("hey: $location");
        ScaffoldMessenger.of(
          cntx,
        ).showSnackBar(SnackBar(content: Text("Invoice $location saved.")));
      } else {
        if (kDebugMode) {
          print(response.data);
        }
        if (cntx.mounted) {
          ScaffoldMessenger.of(
            cntx,
          ).showSnackBar(SnackBar(content: Text(response.data["message"])));
        }

        state = AsyncError("Data malfunctioned", StackTrace.current);
      }

      state = AsyncData(true);
    } on DioException catch (e) {
      print('Status Code: ${e.response?.statusCode}');
      if (cntx.mounted) {
        ScaffoldMessenger.of(
          cntx,
        ).showSnackBar(SnackBar(content: Text(e.response?.data["message"])));
      }
      print('Error Data: ${e.response?.data}');
      print('Headers: ${e.response?.headers}');
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final completeSaleProvider = AsyncNotifierProvider<SaleCompleteNotifier, bool?>(
  () {
    return SaleCompleteNotifier();
  },
);

class BarcodeNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void update(String newValue) {
    state = newValue;
  }

  void clear() {
    state = '';
  }
}

final barcodeProvider = NotifierProvider<BarcodeNotifier, String>(
  () => BarcodeNotifier(),
);

void callAddToCart(
  MedicineModel medicine,
  List<BatchModel> data,
  WidgetRef refMain,
) {
  bool found = false;
  for (final batch in data) {
    if (batch.medicineId!.name == medicine.name && batch.quantity! > 0) {
      found = true;
      refMain
          .read(cartsProvider.notifier)
          .addCart(
            CartModel(
              medicineName: medicine.name ?? " ",
              batchNo: batch.batchNo ?? " ",
              quantity: 1,
              price: medicine.unitPrice ?? 0,
              strength: "${medicine.strength ?? ""}${medicine.unit ?? ""}",
              batchQty: batch.quantity ?? 0,
            ),
          );
      break;
    }
  }
  if (!found) print("not found");
}
