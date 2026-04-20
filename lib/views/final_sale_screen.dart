import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/app/pos_providers.dart';

class FinalSaleScreen extends ConsumerStatefulWidget {
  FinalSaleScreen({Key? key}) : super(key: key);

  @override
  _FinalSaleScreenState createState() => _FinalSaleScreenState();
}

class _FinalSaleScreenState extends ConsumerState<FinalSaleScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _discountController = TextEditingController(text: "0");
  @override
  Widget build(BuildContext context) {
    final carts = ref.watch(cartsProvider);
    double totalPrice = 0;
    double discounted = 0;
    for (final cart in carts) {
      totalPrice += cart.quantity * cart.price;
    }
    discounted =
        totalPrice -
        (totalPrice * (double.tryParse(_discountController.text) ?? 0) / 100);

    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Sale"),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),

      body: Column(
        children: [
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text("Total: ${totalPrice.toStringAsFixed(2)}"),
                  Text("Sub Total: ${discounted.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Customer Name"),
            controller: _nameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Customer Number"),
            keyboardType: TextInputType.number,
            controller: _phoneController,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Discount(%)"),
            keyboardType: TextInputType.number,
            controller: _discountController,
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              List<Map<String, dynamic>> items = [];
              for (final cart in carts) {
                items.add({
                  "medicineName": cart.medicineName,
                  "batchNo": cart.batchNo,
                  "quantity": cart.quantity,
                });
              }
              print(jsonEncode(items));
              ref
                  .read(completeSaleProvider.notifier)
                  .makeSale(
                    items,
                    _nameController.text,
                    _phoneController.text,
                    double.tryParse(_discountController.text) ?? 0,
                    context
                  );
            },
            child: Text("Complete Sale"),
          ),
          Consumer(
            builder: (context, reff, child) {
              final saleComplete = reff.watch(completeSaleProvider);
              return saleComplete.when(
                data: (data) {
                  if (data == true)
                    return Text("Done!");
                  else {
                    return Text("");
                  }
                },
                error: (e, s){print(e);print(s); return Text("error");},
                loading: () => const CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
