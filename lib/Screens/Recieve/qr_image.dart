import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unipay/components/constants.dart';

class QRImage extends StatelessWidget {
  final TextEditingController controller;

  const QRImage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: color12,
      appBar: AppBar(
        title: const Text('Receive Money'),
        backgroundColor: color15,
      ),
      body: Center(
        child: QrImageView(
          data: controller.text,
          version: QrVersions.auto,
          size: 280.0,
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(100, 100),
          ),
        ),
      ),
    );
  }
}
