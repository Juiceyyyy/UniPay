import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/authenticate.dart';
import '../../components/constants.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  TextEditingController amount = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController message = TextEditingController(); // Added controller for message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color12,
      appBar: AppBar(
        title: Text('Send Money'),
        backgroundColor: color15,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Text('Send Money To', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: id,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Enter Recipient's Email",
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
                  controller: amount,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
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
                  controller: message,
                  textAlign: TextAlign.center,
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
                      transfer(context); // Pass the context for navigation
                    },
                    minWidth: double.infinity,
                    height: 50,
                    child: Text("Send", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> transfer(BuildContext context) async {
    User? sender = FirebaseAuth.instance.currentUser;
    String? senderUid = sender?.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch recipient details based on email
    QuerySnapshot recipientQuery = await firestore.collection('users').where('Email', isEqualTo: id.text).get();

    if (recipientQuery.docs.isNotEmpty) {
      String recipientUid = recipientQuery.docs.first.id;
      Map<String, dynamic>? recipientData = recipientQuery.docs.first.data() as Map<String, dynamic>?;

      if (recipientData != null) { // Checking if recipientData is not null
        int valueToAdd = int.tryParse(amount.text) ?? 0;
        int senderCurrentBalance = (await firestore.collection('users').doc(senderUid).get()).data()?['Balance'] ?? 0;
        int recipientCurrentBalance = recipientData['Balance'] ?? 0;

        if (valueToAdd > 0 && senderCurrentBalance >= valueToAdd) {
          int updatedSenderBalance = senderCurrentBalance - valueToAdd;
          int updatedRecipientBalance = recipientCurrentBalance + valueToAdd;

          // Update sender's balance
          await firestore.collection('users').doc(senderUid).update({'Balance': updatedSenderBalance});

          // Update recipient's balance
          await firestore.collection('users').doc(recipientUid).update({'Balance': updatedRecipientBalance});

          // Successfully transferred, navigate back to the dashboard or display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Money sent successfully!'),
            ),
          );

          // Navigate back to the dashboard
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthenticationPage()),
          );
        } else {
          // Show an error message for an insufficient balance or invalid amount
          String errorMessage = (valueToAdd <= 0) ? 'Please enter a valid amount' : 'Insufficient balance for this transaction';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
            ),
          );
        }
      }
    } else {
      // Show an error message if recipient email is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recipient email not found.'),
        ),
      );
    }
  }
}
