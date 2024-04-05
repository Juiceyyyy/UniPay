import 'package:flutter/material.dart';

import '../../components/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: color15,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
       child: Container(
        width: double.infinity,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
    children: [
          Padding(
        padding: const EdgeInsets.all(16.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SizedBox(height: 50),
              TextFormField(
              controller: _nameController,
              enabled: _isEditing,
                cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the focused border color
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _phoneNumberController,
              enabled: _isEditing,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the focused border color
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _addressController,
              enabled: _isEditing,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the focused border color
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              enabled: _isEditing,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change the focused border color
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isEditing)
              ElevatedButton(
                onPressed: () {
                  // Implement your save logic here
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: Text('Save Profile'),
              ),
          ],
        ),
      ),
    ])
       )
      )
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}