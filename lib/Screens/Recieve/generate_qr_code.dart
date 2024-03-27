import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../components/constants.dart';
import 'qr_image.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height:10),
            QrImageView(
              data: '$userEmail',
              version: QrVersions.auto,
              size: 200.0,
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(100, 100),
              ),
            ),
          SizedBox(height:8), //box above amount input box
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the focused border color
                ),
                labelText: 'Enter Amount',
                labelStyle: TextStyle(color: Colors.black), // Change the label color
                // Add any additional properties as needed
              ),
              cursorColor: Colors.black, // Change the cursor color
            ),
          ),
          //This button when pressed navigates to QR code generation
          ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return QRImage(controller: controller,);
                    }),
                  ),
                );
              },
              child: const Text('GENERATE QR CODE')),
        ],
      ),
    );
  }
}