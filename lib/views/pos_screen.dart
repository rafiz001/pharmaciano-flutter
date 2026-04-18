import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmaciano/app/pos_providers.dart';
import 'package:pharmaciano/models/medicine_model.dart';

class PosScreen extends ConsumerWidget {
  PosScreen({super.key});

  final _optionsNotifier = ValueNotifier<List<String>>([]);
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context, WidgetRef refMain) {
    refMain.listen<AsyncValue<List<MedicineModel>?>>(searchProvider, (_, next) {
      next.whenData((data) {
        _optionsNotifier.value =
            data
                ?.map((item) => "${item.name} ${item.strength} ${item.unit}")
                .toList() ??
            [];
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            // final state = refMain.watch(searchProvider);
            Timer? timer;

            return Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                final q = textEditingValue.text;
                if (q.length <= 2) return const Iterable<String>.empty();

                timer?.cancel();
                timer = Timer(const Duration(milliseconds: 500), () {
                  refMain.read(searchProvider.notifier).getSearchResult(q);
                });
                return _optionsNotifier.value;
              },
              fieldViewBuilder: (_, c, f, __) => TextField(
                controller: c,
                focusNode: f,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Search...",
                ),
              ),
              onSelected: (selected){
                
              },
            );
          },
        ),

        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.camera_alt_outlined),
            tooltip: "Barcode Scanner",
          ),
        ],
      ),
      // drawer: Drawer(),
      body: Consumer(
        builder: (context, ref, child) {
          final batches = ref.watch(batchesProvider);
          return batches.when(
            data: (data) => Column(
              children: [
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      itemCount: PosScreen._kOptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(PosScreen._kOptions[index]),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Sub Total:"),
                      Container(
                        width: 1,
                        height: 30,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_right_alt),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            error: (error, st) {
              if (kDebugMode) print(st);
              return Center(child: Text(error.toString()));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
