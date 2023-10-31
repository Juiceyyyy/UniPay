import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipay/Screens/Home/admin_home.dart';
import '../../../../../components/constants.dart';

class GenerateCoin extends StatefulWidget {
  @override
  _GenerateCoinState createState() => _GenerateCoinState();
}

class _GenerateCoinState extends State<GenerateCoin> {
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color12,
      appBar: AppBar(
        title: Text('Generate Coins'),
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
                'Generate Coins',
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
                  style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
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
                      // Call the Generate function
                      generate();
                    },
                    minWidth: double.infinity,
                    height: 50,
                    child: Text("Generate", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generate() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userDoc = firestore.collection('users').doc(uid);
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        int valueToAdd = int.parse(amount.text);
        int currentBalance = (userData['Balance'] ?? 0);
        int updatedBalance = currentBalance + valueToAdd;

        await userDoc.update({'Balance': updatedBalance});

        // Navigate back to the dashboard after generating coins
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
              (route) => false, // Clear the navigation stack
        );
      } else {
        print('User data is null or empty');
        // Handle the case where the user's data is missing
      }
    } else {
      print('User document does not exist');
      // Handle the case where the user's document doesn't exist
    }
  }
}
