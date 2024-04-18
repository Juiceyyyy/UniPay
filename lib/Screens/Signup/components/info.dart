import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/constants.dart';
import '../../Home/user_home.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _pinController = TextEditingController();

  bool _isEditing = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // Load profile data from Firebase Firestore
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = userData['Name'] ?? '';
          _phoneNumberController.text = userData['PhoneNumber'] ?? '';
          _emailController.text = userData['Email'] ?? '';
          _departmentController.text = userData['Department'] ?? '';
          _yearController.text = userData['Year'] ?? '20';
          _pinController.text = userData['Pin'] ?? '';
        });
      }
    }
  }

  Future<void> _saveProfileData() async {
    // Check if any required field is empty
    if (_nameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _departmentController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _pinController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Update profile data in Firebase Firestore
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDoc = firestore.collection('users').doc(user.uid);
      await userDoc.set({
        'Name': _nameController.text,
        'PhoneNumber': _phoneNumberController.text,
        'Email': _emailController.text,
        'Department': _departmentController.text,
        'Year': _yearController.text,
        'Pin' : _pinController.text,
      }, SetOptions(merge: true));
    }

    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: color14,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTextField('Name', _nameController, maxDigits: 50, required: true,),
              SizedBox(height: 20),
              _buildTextField('Phone Number', _phoneNumberController, maxDigits: 10, required: true,),
              SizedBox(height: 20),
              _buildTextField('Email', _emailController, maxDigits: 50, required: true,),
              SizedBox(height: 20),
              _buildTextField('Department', _departmentController, maxDigits: 50, required: true,),
              SizedBox(height: 20),
              _buildTextField('Year', _yearController, maxDigits: 4, required: true, clue: 'Enter your year of admission'),
              SizedBox(height: 20),
              _buildTextField('Pin', _pinController, maxDigits: 4, required: true, clue: 'Enter a 4 digit PIN number, this will be used for all transactions.'),
              SizedBox(height: 20),
              if (_isEditing)
                ElevatedButton(
                  onPressed: () async {
                    await _saveProfileData();
                  },
                  child: Text(
                    'Save Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color15,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {required int maxDigits, required bool required, String? clue}) {
    TextInputType keyboardType = TextInputType.text; // Default to text input type

    // Check if the label corresponds to phone number or year, then set keyboardType accordingly
    if (label == 'Phone Number' || label == 'Year' || label == 'Pin') {
      keyboardType = TextInputType.number;
    }

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: _isEditing,
            cursorColor: color14,
            style: TextStyle(color: color14),
            keyboardType: keyboardType, // Use the determined keyboardType
            inputFormatters: [
              if (keyboardType == TextInputType.number) // Only allow numeric input if keyboardType is number
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow numeric input
              LengthLimitingTextInputFormatter(maxDigits), // Limit the length of input
            ],
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: color14),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: color14),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color14),
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: label == 'Year' || label == 'Pin'
                  ? IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  _showClueDialog(context, label, clue);
                },
              )
                  : null,
            ),
            validator: (value) {
              if (required && value!.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
}

  void _showClueDialog(BuildContext context, String label, String? clue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label),
          content: Text(clue ?? ''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
