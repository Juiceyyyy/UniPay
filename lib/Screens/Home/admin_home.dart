import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipay/Screens/Login/login_screen.dart';
import 'package:unipay/components/constants.dart';
import 'package:unipay/Screens/Home/components/generateCoin.dart';
import '../Send/sendmoney.dart';
import 'components/dashboard.dart';
import 'components/deleteCoin.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color12,
      appBar: AppBar(
        title: Text('Admin'),
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
              title: Text('Generate Coins'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateCoin()));
              },
            ),
            ListTile(
              title: Text('Destroy Coins'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DestroyCoin()));
              },
            ),
            ListTile(
              title: Text('Send'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoney()));
              },
            ),
            ListTile(
              title: Text('Receive'),
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
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
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
              },
            ),
          ],
        ),
      ),
      body: Dashboard(),
    );
  }
}
