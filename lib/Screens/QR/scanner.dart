import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:unipay/components/constants.dart';

import 'components/myqr.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController();
  String? scannedData;
  double resultSectionHeight = 100.0; // Adjust height as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
        backgroundColor: color14,
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.white);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_rounded),
            color: Colors.white,
            onPressed: () async {
              await cameraController.stop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyQR())).then((_) {
                // Resume camera when returning to the Scanner page
                cameraController.start();
                            });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                setState(() {
                  final List<Barcode> barcodes = capture.barcodes;
                  final Uint8List? image = capture.image;
                  if (barcodes.isNotEmpty) {
                    scannedData = barcodes.first.rawValue;
                    debugPrint('Barcode found! $scannedData');
                  }
                });
              },
            ),
          ),
          Container(
            height: resultSectionHeight,
            color: color12,
            child: Center(
              child: (scannedData != null)
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Data: $scannedData'),
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () {
                      _copyResultToClipboard(scannedData!);
                    },
                  ),
                ],
              )
                  : const Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }

  void _copyResultToClipboard(String data) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $data'),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
