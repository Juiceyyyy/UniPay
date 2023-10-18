import 'package:flutter/material.dart';
import 'package:unipay/Screens/Login/login_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.purpleAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
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
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purpleAccent, // Setting the button color to deep orange
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
}