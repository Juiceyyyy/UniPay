import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipay/Screens/Home/home_page.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorText = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          if (_errorText.isNotEmpty)
            Text(
              _errorText,
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(height: defaultPadding / 2),

          ElevatedButton(
            onPressed: () {
              _registerUser();
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the current user and UID
      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;

      // Now you have the UID, you can store it in Firestore or perform other actions.
      // Reference to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a document reference using the user's UID
      DocumentReference userDoc = firestore.collection('users').doc(uid);

      // Define the user data to be stored
      Map<String, dynamic> userData = {
        // 'displayName': user?.displayName,
        'email': user?.email,
        'admin': false,
      };

      // Set the user data in the Firestore document
      await userDoc.set(userData);
      print('User data added to Firestore');


      // The user is registered successfully.
      //print("User registered: ${userCredential.user?.email}");
      // Redirect to another screen or perform any other necessary actions here.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false, // Clear the navigation stack
      );
    } catch (e) {
      // Handle registration errors here.
      print("Error registering user: $e");
      setState(() {
        _errorText = "Error registering user: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
