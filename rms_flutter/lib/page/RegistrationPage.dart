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
      String uRole = selectedRole ?? '';

      if (uRole.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a role')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      final response = await _sendDataToBackend(
        uName, uEmail, uPassword, uPhone, uAddress, uRole,
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Registration successful!');
        // Optionally navigate or show a success message
      } else if (response.statusCode == 409) {
        print('User already exists!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User already exists!')),
        );
      } else {
        print('Registration failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed! Please try again.')),
        );
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String name,
      String email,
      String password,
      String phone,
      String address,
      String role,
      ) async {
    // const String url = 'https://8ccf-103-205-69-8.ngrok-free.app/register'; // Android emulator
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
      body: Padding(
        padding: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Registration Form",
                  style: TextStyle(fontSize: 40, color: Colors.blue),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    label: Text("Full Name"),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    label: Text("Email"),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text("Password"),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text("Rewrite Password"),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phone,
                  decoration: InputDecoration(
                    label: Text("Contact Number"),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: address,
                  decoration: InputDecoration(
                    label: Text("Permanent Address"),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Role:'),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'ADMIN',
                            groupValue: selectedRole,
                            onChanged: (String? value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                          ),
                          Text('Admin'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'WAITER',
                            groupValue: selectedRole,
                            onChanged: (String? value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                          ),
                          Text('Waiter'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'USER',
                            groupValue: selectedRole,
                            onChanged: (String? value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                          ),
                          Text('User'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _register,
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}