// main.dart

import 'package:flutter/material.dart';
import 'login_page.dart'; // Importing the login_page.dart file
import 'registration_page.dart'; // Importing the registration_page.dart file

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // You can set the initial route to login if you want to start with the login page.
      routes: {
        '/login': (context) => LoginPage(), // Set LoginPage as the route named '/login'
        '/registration': (context) => RegistrationPage(), // Set RegistrationPage as the route named '/registration'
      },
    );
  }
}
