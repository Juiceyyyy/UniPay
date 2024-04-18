import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../screens/Signup/components/or_divider.dart';
import '../../../screens/Signup/components/social_icon.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'info.dart';

class SocalSignUp extends StatelessWidget {
  const SocalSignUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocalIcon(
              iconSrc: "assets/icons/google-plus.svg",
              press: () {
                _handleGoogleSignIn(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      // Trigger Google sign-in
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Check if the user is already registered
          final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (!userSnapshot.exists) {
            // User is not registered, register the user
            await _registerUser(user);
          }

          // Redirect to home page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => InfoPage()),
                (route) => false,
          );
        }
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle error
    }
  }

  Future<void> _registerUser(User user) async {
    try {
      // Reference to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a document reference using the user's UID
      DocumentReference userDoc = firestore.collection('users').doc(user.uid);

      // Define the user data to be stored
      Map<String, dynamic> userData = {
        'Email': user.email,
        'Balance': 0,
        'Admin': false,
      };

      // Set the user data in the Firestore document
      await userDoc.set(userData);
      print('User data added to Firestore');

      // Create a subcollection 'transactions' for the user
      CollectionReference transactionsCollection = userDoc.collection('transactions');

      // Add a dummy transaction document
      await transactionsCollection.add({
        'senderName': 'UniPay',
        'amount': 0,
        'dateTime': DateTime.now(),
      });
      print('Transaction added');
    } catch (e) {
      // Handle registration errors
      print("Error registering user: $e");
    }
  }
}
