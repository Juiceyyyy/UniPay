import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unipay/components/constants.dart';

class MyQR extends StatefulWidget {
  @override
  _MyQRState createState() => _MyQRState();
}

class _MyQRState extends State<MyQR> {
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Call fetchUserData when the widget is initialized
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "Email not found";
      });
    }
  }

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
          data: '$userEmail',
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
