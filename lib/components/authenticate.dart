import 'package:flutter/material.dart';
import '../Screens/Home/admin_home.dart';
import '../Screens/Home/user_home.dart';
import '../main.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      checkUserAuthentication();
    });
  }

  Future<void> checkUserAuthentication() async {
    if (isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
