import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/app/pos_providers.dart';
import 'package:pharmaciano/models/cart_model.dart';
import 'package:pharmaciano/models/medicine_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharmaciano/views/barcode_window.dart';

class PosScreen extends ConsumerWidget {
  PosScreen({super.key});
  /*
  void showBarcodeScanner(BuildContext ctx) {
    showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        content: 
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(onPressed: () {}, child: const Text('Yes')),
        ],
      ),
    );
  }
*/
 final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef refMain) {
    final batches = refMain.watch(batchesProvider);
    final barcode = refMain.listen(barcodeProvider, (prev,next){
      _controller.text=next;
    });
    return batches.when(
      data: (data) => Scaffold(
        appBar: AppBar(
          title: TypeAheadField<MedicineModel>(
            controller: _controller,
            suggestionsCallback: (query) async {
              if (query.length <= 2) return [];
              return await getSearchResult(query);
            },
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                border: InputBorder.none,
                label: Text("Search by medicine..."),
              ),
            ),
            itemBuilder: (context, medicine) => ListTile(
              title: Text(
                "${medicine.name} ${medicine.strength} ${medicine.unit}",
              ),
            ),
            onSelected: (medicine) {
              _controller.clear();
              bool found = false;
              for (final batch in data) {
                if (batch.medicineId!.name == medicine.name &&
                    batch.quantity! > 0) {
                  found = true;
                  refMain
                      .read(cartsProvider.notifier)
                      .addCart(
                        CartModel(
                          medicineName: medicine.name ?? " ",
                          batchNo: batch.batchNo ?? " ",
                          quantity: 1,
                          price: medicine.unitPrice ?? 0,
                          strength:
                              "${medicine.strength ?? ""}${medicine.unit ?? ""}",
                          batchQty: batch.quantity ?? 0,
                        ),
                      );
                  break;
                }
              }
              if (!found) print("not found");
            },
            debounceDuration: const Duration(milliseconds: 500),
            loadingBuilder: (context) => const LinearProgressIndicator(),
            errorBuilder: (context, error) => Text("Error: $error"),
            emptyBuilder: (context) => const Text("No medicines found"),
          ),

          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              onPressed: () {
                if (!Platform.isLinux && !Platform.isWindows) {
                  // print(Platform.operatingSystem);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarcodeWindow()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "This device is not supported for barcode scanning feature.",
                      ),
                    ),
                  );
                }
              },
              icon: Icon(Icons.camera_alt_outlined),
              tooltip: "Barcode Scanner",
            ),
          ],
        ),
        // drawer: Drawer(),
        body: Column(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final carts = ref.watch(cartsProvider);
                  print(carts);
                  return ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "${carts[index].medicineName} ${carts[index].strength}",
                              ),
                              Text(
                                "${carts[index].batchNo}: ${carts[index].batchQty}unit",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text("${carts[index].price.toString()} ৳"),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(cartsProvider.notifier)
                                      .quantity(
                                        carts[index].batchNo,
                                        carts[index].quantity - 1,
                                      );
                                },
                                icon: Icon(Icons.horizontal_rule),
                              ),
                              Text(carts[index].quantity.toString()),
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(cartsProvider.notifier)
                                      .quantity(
                                        carts[index].batchNo,
                                        carts[index].quantity + 1,
                                      );
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Consumer(
                builder: (contex, ref, child) {
                  final carts = ref.watch(cartsProvider);
                  double totalPrice = 0;
                  for (final cart in carts) {
                    totalPrice += cart.quantity * cart.price;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Sub Total: ${totalPrice.toStringAsFixed(2)}"),
                      Container(
                        width: 1,
                        height: 30,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/posComplete");
                        },
                        icon: Icon(Icons.arrow_right_alt),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      error: (error, stackTrace) {
        print(stackTrace);
        return Scaffold(appBar: AppBar(), body: Text(error.toString()));
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

