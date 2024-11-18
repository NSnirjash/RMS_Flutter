import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rms_flutter/page/LoginPage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();

  String? selectedRole;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _register() async {

    if (_formKey.currentState!.validate()) {
      String uName = name.text;
      String uEmail = email.text;
      String uPassword = password.text;
      String uPhone = phone.text;
      String uAddress = address.text;
      String uRole = selectedRole ?? 'Other';


      // Send data to the server
      final response = await _sendDataToBackend(uName, uEmail, uPassword, uPhone, uAddress, uRole);

      if (response.statusCode == 201 || response.statusCode == 200  ) {
        // Registration successful
        print('Registration successful!');
      } else if (response.statusCode == 409) {
        // User already exists
        print('User already exists!');
      } else {
        print('Registration failed with status: ${response.statusCode}');
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String name, String email, String password, String phone, String address, String role) async {
    const String url = 'http://localhost:8090/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
        'role': role,
      }),
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/register_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(name, "Full Name", Icons.person),
                      const SizedBox(height: 20),
                      _buildTextField(email, "Email", Icons.email),
                      const SizedBox(height: 20),
                      _buildTextField(password, "Password", Icons.lock, isPassword: true),
                      const SizedBox(height: 20),
                      _buildTextField(confirmPassword, "Confirm Password", Icons.lock, isPassword: true),
                      const SizedBox(height: 20),
                      _buildTextField(phone, "Phone Number", Icons.phone),
                      const SizedBox(height: 20),
                      _buildTextField(address, "Address", Icons.home),
                      const SizedBox(height: 20),
                      _buildRoleSelection(),
                      const SizedBox(height: 20),
                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Register", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleOption('Admin', 'ADMIN'),
        _buildRoleOption('Waiter', 'WAITER'),
        _buildRoleOption('User', 'USER'),
      ],
    );
  }

  Widget _buildRoleOption(String label, String value) {
    return Expanded(
      child: RadioListTile<String>(
        title: Text(label, style: TextStyle(color: Colors.white)),
        value: value,
        groupValue: selectedRole,
        onChanged: (newValue) => setState(() => selectedRole = newValue),
      ),
    );
  }
}
