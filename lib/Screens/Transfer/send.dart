import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/constants.dart';
import '../Home/user_home.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  TextEditingController amount = TextEditingController();
  TextEditingController id = TextEditingController();

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
              Text('Send Money To', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), // Add logic to fetch the name
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
                    hintText: "Enter Recipients Email",
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
                      // Add navigation logic
                      transfer();
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
  Future<void> transfer() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userDoc = firestore.collection('users').doc(uid);
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<
          String,
          dynamic>?;

      if (userData != null) {
        int valueToAdd = int.parse(amount.text);
        // TODO: fetch user-email data and userid from that
        int currentBalance = (userData['Balance'] ?? 0);
        int updatedBalance = currentBalance - valueToAdd;
        //TODO :add transferred to logic

        await userDoc.update({'Balance': updatedBalance});

        // Navigate back to the dashboard after generating coins
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false, // Clear the navigation stack
        );
      }
    }
  }
}
