import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipay/Screens/Login/login_screen.dart';
import 'package:unipay/components/constants.dart';
import '../Profile/profile.dart';
import '../Recieve/generate_qr_code.dart';
import '../Send/sendmoney.dart';
import '../Settings/settings.dart';
import 'components/dashboard.dart';

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
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

                Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoney()));
                // Add functionality here for Button 2
              },
            ),
            ListTile(
              title: Text('Receive'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateQRCode()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
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
