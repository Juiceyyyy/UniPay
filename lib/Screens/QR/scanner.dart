import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:unipay/Screens/QR/components/myqr.dart';
import 'package:unipay/components/constants.dart';

class Scanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double qrViewHeight = screenHeight * 0.6539;
    double resultSectionHeight = screenHeight * 0.1;

    return WillPopScope(
      onWillPop: () async {
        // Dispose the controller when leaving the Scanner page
        controller?.dispose();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
          backgroundColor: color15,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.qr_code_rounded),
              onPressed: () async {
                if (controller != null) {
                  await controller!.pauseCamera();
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyQR())).then((_) {
                  // Resume camera when returning to the Scanner page
                  if (controller != null) {
                    controller!.resumeCamera();
                  }
                });
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context, qrViewHeight)),
            Container(
              height: resultSectionHeight,
              color: color12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (result != null)
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Data: ${result!.code}'),
                      IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () {
                          _copyResultToClipboard();
                        },
                      ),
                    ],
                  )
                      : Text('Scan a code'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context, double qrViewHeight) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: color12,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _copyResultToClipboard() {
    if (result != null) {
      final resultText = result!.code ?? '';
      Clipboard.setData(ClipboardData(text: resultText));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard: $resultText'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Resume camera when returning to the Scanner page
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


