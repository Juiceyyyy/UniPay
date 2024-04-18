import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unipay/Screens/Home/user_home.dart';
import '../../../components/constants.dart';

class PinPage extends StatefulWidget {
  final senderUid;
  final valueToAdd;
  final recipientUid;
  final senderCurrentBalance;
  final recipientCurrentBalance;
  final String senderName;
  final String recipientName;

  const PinPage({
    Key? key,
    required this.senderUid,
    required this.valueToAdd,
    required this.senderName,
    required this.recipientName,
    required this.recipientUid,
    required this.senderCurrentBalance,
    required this.recipientCurrentBalance,
  }) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}


class _PinPageState extends State<PinPage> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    // Initialize text editing controllers for each digit input field
    controllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose text editing controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> checkPin(BuildContext context) async {
    // Combine the input PIN from all controllers
    String inputPin = controllers.fold<String>(
        '', (previousValue, controller) => previousValue + controller.text);

    try {
      // Retrieve the PIN document from Firestore
      DocumentSnapshot pinDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.senderUid)
          .get();

      // Check if the PIN document exists
      if (pinDoc.exists) {
        // Get the data from the user document
        Map<String, dynamic>? userData = pinDoc.data() as Map<String, dynamic>?;

        // Check if the user data is not null and contains the PIN field
        if (userData != null && userData.containsKey('Pin')) {
          // Extract the stored PIN from the user data
          String? storedPin = userData['Pin'] as String?;

          // Check if the stored PIN matches the input PIN
          if (storedPin != null && inputPin == storedPin) {
            // If PIN matches, update balances and store transaction
            int updatedSenderBalance =
                widget.senderCurrentBalance - widget.valueToAdd;
            int updatedRecipientBalance =
                widget.recipientCurrentBalance + widget.valueToAdd;

            // Update sender's balance
            await FirebaseFirestore.instance.collection('users').doc(widget.senderUid).update(
                {'Balance': updatedSenderBalance}
            );

            // Update recipient's balance
            await FirebaseFirestore.instance.collection('users').doc(widget.recipientUid).update(
                {'Balance': updatedRecipientBalance}
            );

            // Store transaction details for the sender
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.senderUid)
                .collection('transactions')
                .add({
              'Name': widget.recipientName,
              'Type': 'Debited',
              'Amount': widget.valueToAdd,
              'Timestamp': Timestamp.now(),
            });

            // Store transaction details for the recipient
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.recipientUid)
                .collection('transactions')
                .add({
              'Name': widget.senderName,
              'Type': 'Credited',
              'Amount': widget.valueToAdd,
              'Timestamp': Timestamp.now(),
            });

            // Navigate to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );

            // Successfully transferred, navigate back to the dashboard or display a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Money sent successfully!'),
              ),
            );

          } else {
            // If PIN doesn't match, show an error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Incorrect PIN. Please try again.'),
              ),
            );
          }
        } else {
          // If the PIN field is not found in the user data, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PIN not found in user data.'),
            ),
          );
        }
      } else {
        // If the user document doesn't exist, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User document not found.'),
          ),
        );
      }
    } catch (error) {
      // Handle any errors that occur during PIN retrieval or comparison
      print('Error checking PIN: $error');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter PIN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: color14,
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                    (index) => SizedBox(
                  height: 68,
                  width: 64,
                  child: TextFormField(
                    controller: controllers[index],
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // If the field is empty, move focus to the previous field
                        if (index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      } else if (value.length == 1) {
                        // If a digit is entered, move focus to the next field if not the last field
                        if (index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          // Unfocus when the last field is reached
                          FocusScope.of(context).unfocus();
                        }
                      }
                    },
                    onEditingComplete: () {
                      // If the field is submitted (e.g., user taps 'done' on the keyboard), move focus to the next field if not the last field
                      if (index < 3) {
                        FocusScope.of(context).nextFocus();
                      } else {
                        // Unfocus when the last field is submitted
                        FocusScope.of(context).unfocus();
                      }
                    },
                    style: Theme.of(context).textTheme.headline6,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                color: color15,
                child: MaterialButton(
                  onPressed: () {
                    checkPin(context);
                  },
                  minWidth: double.infinity,
                  height: 50,
                  child: Text(
                    "Pay",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
