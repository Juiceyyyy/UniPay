import 'package:flutter/material.dart';
import 'package:unipay/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while checking authentication state
        } else if (snapshot.hasData) {
          // A user is signed in, show "Sign Out" instead of "Sign Up"
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                login ? "Don’t have an Account ? " : "Already have an Account ? ",
                style: const TextStyle(color: kPrimaryColor),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text(
                  login ? "Sign Up" : "Sign Out",
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        } else {
          // No user is signed in, show "Sign Up" for registration
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                login ? "Don’t have an Account ? " : "Already have an Account ? ",
                style: const TextStyle(color: kPrimaryColor),
              ),
              GestureDetector(
                onTap: press as void Function()?,
                child: Text(
                  login ? "Sign Up" : "Login",
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
