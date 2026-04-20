import 'package:flutter/material.dart';

@immutable
class CartModel {
  const CartModel({
    required this.medicineName,
    required this.batchNo,
    required this.quantity,
    required this.price,
    required this.strength,
    required this.batchQty,
  });

  // All properties should be `final` on our class.
  final String medicineName;
  final String batchNo;
  final int quantity;
  final double price;
  final String strength;
  final int batchQty;

  // Since CartModel is immutable, we implement a method that allows cloning the
  // CartModel with slightly different content.
  CartModel copyWith({String? medicineName, String? batchNo, int? quantity, double? price, String? strength, int? batchQty}) {
    return CartModel(
      medicineName: medicineName ?? this.medicineName,
      batchNo: batchNo ?? this.batchNo,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      strength: strength ?? this.strength,
      batchQty: batchQty ?? this.batchQty,

    );
  }
}