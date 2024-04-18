import 'package:flutter/material.dart';
import '../../../components/constants.dart';


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: color14,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to our innovative event payment system!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Our app is designed to revolutionize the way event transactions are conducted. Say goodbye to long queues and manual processes. With our user-friendly mobile application, both event organizers and attendees can enjoy seamless payments and real-time tracking. We offer diverse payment options and efficient event management tools to enhance accountability, transparency, and security. Join us in ushering in a future where event payments are conducted securely, conveniently, and efficiently.',
              style: TextStyle(fontSize: 15,),textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text(
              'Developers',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Joshua Menezes',style: TextStyle(fontSize: 15)),
            Text('Shweta Nadar',style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}