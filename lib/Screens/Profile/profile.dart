import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _yearController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _phoneNumberController.text = prefs.getString('phoneNumber') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _departmentController.text = prefs.getString('department') ?? '';
      _yearController.text = prefs.getString('year') ?? '20';
    });
  }

  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('phoneNumber', _phoneNumberController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('department', _departmentController.text);
    await prefs.setString('year', _yearController.text);
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTextField('Name', _nameController, maxDigits: 50),
              SizedBox(height: 20),
              _buildTextField('Phone Number', _phoneNumberController, maxDigits: 10),
              SizedBox(height: 20),
              _buildTextField('Email', _emailController, maxDigits: 50),
              SizedBox(height: 20),
              _buildTextField('Department', _departmentController, maxDigits: 50),
              SizedBox(height: 20),
              _buildTextField('Year', _yearController, maxDigits: 4),
              SizedBox(height: 20),
              if (_isEditing)
                ElevatedButton(
                  onPressed: () async {
                    await _saveProfileData();
                    setState(() {
                      _isEditing = false;
                    });
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

  Widget _buildTextField(String label, TextEditingController controller, {required int maxDigits}) {
    TextInputType keyboardType = TextInputType.text; // Default to text input type

    // Check if the label corresponds to phone number or year, then set keyboardType accordingly
    if (label == 'Phone Number' || label == 'Year') {
      keyboardType = TextInputType.number;
    }

    return TextFormField(
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
      ),
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
