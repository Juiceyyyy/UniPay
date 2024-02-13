import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unipay/Screens/Home/admin_home.dart';
import '../../../../../components/constants.dart';

class DestroyCoin extends StatefulWidget {
  @override
  _DestroyCoinState createState() => _DestroyCoinState();
}

class _DestroyCoinState extends State<DestroyCoin> {
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color12,
      appBar: AppBar(
        title: Text('Destroy Coins'),
        backgroundColor: color15,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Text(
                'Destroy Coins',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: amount,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  onTap: () {
                    // Add onTap logic
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Amount",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  color: color15,
                  child: MaterialButton(
                    onPressed: () {
                      showConfirmationDialog();
                    },
                    minWidth: double.infinity,
                    height: 50,
                    child: Text("Destroy",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Are you sure you want to destroy ${amount.text} coins?"),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Confirm',
          textColor: Colors.red,
          onPressed: () {
            destroy(context); // Pass the context to destroy function
          },
        ),
      ),
    );
  }

  Future<void> destroy(BuildContext context) async {
    User? sender = FirebaseAuth.instance.currentUser;
    String? senderUid = sender?.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    int valueToSub = int.tryParse(amount.text) ?? 0;
    int senderCurrentBalance = (await firestore.collection('users').doc(
        senderUid).get()).data()?['Balance'] ?? 0;

    if (valueToSub > 0 && senderCurrentBalance >= valueToSub) {
      int updatedSenderBalance = senderCurrentBalance - valueToSub;

      // Update sender's balance
      await firestore.collection('users').doc(senderUid).update(
          {'Balance': updatedSenderBalance});

      // Successfully transferred, navigate back to the dashboard or display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coins destroyed successfully!'),
        ),
      );

      // Navigate back to the dashboard
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
    (route) => false);// Clear the navigation stack

    } else {
      // Show an error message for an insufficient balance or invalid amount
      String errorMessage = (valueToSub <= 0)
          ? 'Please enter a valid amount'
          : 'Insufficient balance for this transaction';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }
}
