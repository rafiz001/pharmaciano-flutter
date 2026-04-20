import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmaciano/app/pos_providers.dart';

class BarcodeWindow extends ConsumerStatefulWidget {
  BarcodeWindow({Key? key}) : super(key: key);

  @override
  _BarcodeWindowState createState() => _BarcodeWindowState();
}

class _BarcodeWindowState extends ConsumerState<BarcodeWindow> {
  late MobileScannerController _controller;
  bool flashOn = false;
  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      torchEnabled: flashOn,
      autoZoom: true,
      // detectionSpeed:
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("barcode"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                flashOn = !flashOn;
                _controller.toggleTorch();
              });
            },
            icon: Icon(flashOn ? Icons.flash_on_sharp : Icons.flash_off_sharp),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,

            onDetect: (capture) async {
              String? result = capture.barcodes.first.rawValue;
              if (result != null) {
                ref
                    .read(barcodeProvider.notifier)
                    .update(capture.barcodes.first.rawValue!);
                await _controller.stop();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
              if (kDebugMode) {
                print(capture.barcodes.first.rawValue);
              }
            },
          ),
          BarcodeOverlay(
            boxFit: BoxFit.cover,
            controller: _controller, // Same controller used above
            color: Colors.green, // Box color
            style: PaintingStyle.stroke, // Just the outline
          ),
        ],
      ),
    );
  }
}
