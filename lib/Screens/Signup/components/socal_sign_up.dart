import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unipay/Screens/Home/user_home.dart';
import '../../../screens/Signup/components/or_divider.dart';
import '../../../screens/Signup/components/social_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Home/admin_home.dart';

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
            // SocalIcon(
            //   iconSrc: "assets/icons/facebook.svg",
            //   press: () {
            //     // Implement Facebook Sign-In here
            //   },
            // ),
            // SocalIcon(
            //   iconSrc: "assets/icons/twitter.svg",
            //   press: () {
            //     // Implement Twitter Sign-In here
            //   },
            // ),
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

//checks if user is already registered in db, if not then assigns default values
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          scopes: ['email']).signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult = await FirebaseAuth.instance
          .signInWithCredential(credential);

      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;

      // Reference to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a document reference using the user's UID
      DocumentReference userDoc = firestore.collection('users').doc(uid);

      // Check if the user document exists
      final userDocSnapshot = await userDoc.get();
      if (!userDocSnapshot.exists) {
        // User document doesn't exist, set the user data
        Map<String, dynamic> userData = {
          'Email': user?.email,
          'Balance': 0, // Initialize 'Balance' to 0 by default
          'Admin': false,
        };

        // Set the user data in the Firestore document
        await userDoc.set(userData);
        print('User data added to Firestore');
      }

      // Check the 'Admin' status after signing in
      bool isAdmin = userDocSnapshot['Admin'] ?? false;

      if (isAdmin) {
        // If the user is an admin, redirect to the admin page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
              (route) => false,
        );
      } else {
        // If the user is not an admin, redirect to the home page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }
}