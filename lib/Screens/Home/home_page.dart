import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipay/Screens/Login/login_screen.dart';
import 'package:unipay/constants.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color12,
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: color15,
      ),
      drawer: Drawer(
        backgroundColor: color12,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: color15,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Add functionality here for Button 1
              },
            ),
            ListTile(
              title: Text('Transactions'),
              onTap: () {
                // Add functionality here for Button 1
              },
            ),
            ListTile(
              title: Text('Send'),
              onTap: () {
                // Add functionality here for Button 2
              },
            ),ListTile(
              title: Text('Recieve'),
              onTap: () {
                // Add functionality here for Button 1
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Add functionality here for Button 1
              },
            ),
          ],
        ),
      ),
      body: Container(

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 20),
              Text(
                'Welcome to the Home Page!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signOut(context); // Call the _signOut function when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color15, // Setting the button color to primary
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false, // Clear the navigation stack
      );
    } catch (e) {
      // Handle sign-out errors, if any
      print('Error signing out: $e');
    }
  }
}