@ -7,33 +7,83 @@ class RegistrationPage extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Registration'),
),
backgroundColor: Colors.white, // Set the background color to white

body: Padding(
padding: EdgeInsets.all(16.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: <Widget>[
Image.network(
'https://cdn.dribbble.com/users/2213143/screenshots/7971141/media/184cdea9758c029d9feef05432222403.gif', // Replace this with the URL of your GIF
height: 200,
width: 200,
),
SizedBox(height: 20),
TextFormField(
style: TextStyle(color: Colors.black),
decoration: InputDecoration(
labelText: 'Username',
border: OutlineInputBorder(),
labelStyle: TextStyle(color: Colors.grey[800]!, fontWeight: FontWeight.bold),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.grey[400]!),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.grey[400]!),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
),
filled: true,
fillColor: Colors.white,
),
),
SizedBox(height: 20),
TextFormField(
style: TextStyle(color: Colors.black),
decoration: InputDecoration(
labelText: 'Email',
border: OutlineInputBorder(),
labelStyle: TextStyle(color: Colors.grey[800]!, fontWeight: FontWeight.bold),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.grey[400]!),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.grey[400]!),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
),
filled: true,
fillColor: Colors.white,
),
),
SizedBox(height: 20),
TextFormField(
style: TextStyle(color: Colors.black),
decoration: InputDecoration(
labelText: 'Password',
border: OutlineInputBorder(),
labelStyle: TextStyle(color: Colors.grey[800]!, fontWeight: FontWeight.bold),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.grey[400]!),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.grey[400]!),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10.0),
borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
),
filled: true,
fillColor: Colors.white,
),
obscureText: true,
),
@ -42,14 +92,27 @@ class RegistrationPage extends StatelessWidget {
onPressed: () {
// TODO: Implement registration functionality
},
child: Text('Register'),
style: ElevatedButton.styleFrom(
primary: Colors.deepOrange, // Setting the button color to deep orange
padding: EdgeInsets.symmetric(vertical: 16.0),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10.0),
),
),
child: Text(
'Register',
style: TextStyle(color: Colors.white, fontSize: 16.0),
),
),
SizedBox(height: 20),
TextButton(
onPressed: () {
Navigator.pop(context); // Navigate back to the previous screen (in this case, the login page)
},
child: Text('Back to Login'),
child: Text(
'Back to Login',
style: TextStyle(color: Colors.deepOrange, fontSize: 16.0),
),
),
],
),
