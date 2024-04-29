import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipay/Screens/Send/components/pin.dart';
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
        title: Text('Send Money',style: TextStyle(color: Colors.white),),
        backgroundColor: color15,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Text('Send Money To',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: id,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: amount,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
              // SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child: TextField(
              //     controller: message,
              //     textAlign: TextAlign.center,
              //     cursorColor: Colors.black,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     decoration: InputDecoration(
              //       hintText: "Message",
              //       hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide.none,
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide.none,
              //       ),
              //     ),
              //   ),
              // ),
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
                    child: Text(
                      "Send",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
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
    QuerySnapshot recipientQuery = await firestore
        .collection('users')
        .where('Email', isEqualTo: id.text)
        .get();

    if (recipientQuery.docs.isNotEmpty) {
      String recipientUid = recipientQuery.docs.first.id;

      // Check if the recipient is not the same as the sender
      if (recipientUid != senderUid) {
        Map<String, dynamic>? recipientData =
        recipientQuery.docs.first.data() as Map<String, dynamic>?;

        if (recipientData != null) {
          // Fetch sender name
          String senderName =
          await fetchUserName(senderUid ?? ''); // Fetch sender name

          // Fetch recipient name
          String recipientName = await fetchUserName(
              recipientUid); // Fetch recipient name using recipientUid

          int valueToAdd = int.tryParse(amount.text) ?? 0;
          int senderCurrentBalance = (await firestore
              .collection('users')
              .doc(senderUid)
              .get())
              .data()?['Balance'] ?? 0;
          int recipientCurrentBalance = recipientData['Balance'] ?? 0;

          if (valueToAdd > 0 && senderCurrentBalance >= valueToAdd) {
            // Navigate to PinPage with all necessary parameters
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PinPage(
                      senderUid: senderUid,
                      valueToAdd: valueToAdd,
                      recipientUid: recipientUid,
                      senderCurrentBalance: senderCurrentBalance,
                      recipientCurrentBalance: recipientCurrentBalance,
                      senderName: senderName,
                      recipientName: recipientName,
                    ),
              ),
            );
          } else {
            // Show an error message for an insufficient balance or invalid amount
            String errorMessage = (valueToAdd <= 0)
                ? 'Please enter a valid amount'
                : 'Insufficient balance for this transaction';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
              ),
            );
          }
        }
      } else {
        // Show an error message if sender tries to send money to themselves
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You can't send money to yourself."),
          ),
        );
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

// Function to fetch user name from Firestore
  Future<String> fetchUserName(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      return userDoc['Name'] ??
          'Unknown'; // Return user's name or 'Unknown' if not found
    } else {
      return 'Unknown'; // Return 'Unknown' if user document does not exist
    }
  }
}