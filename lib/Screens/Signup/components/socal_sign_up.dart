import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../screens/Signup/components/or_divider.dart';
import '../../../screens/Signup/components/social_icon.dart';

class SocalSignUp extends StatelessWidget {
   const SocalSignUp({
    Key? key,
  }) : super(key: key);

  void updateGoogleSignInClientId() {
    const String clientId = '952786014191-4babja8nujkbdub2rgj9ej8fq10vboss.apps.googleusercontent.com';

  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['email']).signIn(); // Specify the desired scopes
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user is signed in
      if (authResult.user != null) {
        // Navigate to the next screen or perform any other action
      }
    } catch (e) {
      // Handle errors (e.g., if the user cancels the sign-in)
      print("Error signing in with Google: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocalIcon(
              iconSrc: "assets/icons/facebook.svg",
              press: () {
                // Implement Facebook Sign-In here
              },
            ),
            SocalIcon(
              iconSrc: "assets/icons/twitter.svg",
              press: () {
                // Implement Twitter Sign-In here
              },
            ),
            SocalIcon(
              iconSrc: "assets/icons/google-plus.svg",
              press: _handleGoogleSignIn,
            ),
          ],
        ),
      ],
    );
  }
}



