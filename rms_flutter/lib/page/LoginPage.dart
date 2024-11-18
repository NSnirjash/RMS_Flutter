import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/page/RegistrationPage.dart';
import 'package:rms_flutter/page/UserPage.dart';
import 'package:rms_flutter/service/AuthService.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = FlutterSecureStorage();
  AuthService authService = AuthService();

  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);
      final role = await authService.getUserRole(); // Get role from AuthService

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (role == 'USER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    }
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
                image: AssetImage('assets/login_image.jpg'), // Add your background image here
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Color overlay for text readability
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Main content with padding
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Please log in to continue",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Email TextField
                    TextField(
                      controller: email,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Password TextField
                    TextField(
                      controller: password,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                      ),
                      obscureText: true,
                    ),

                    SizedBox(height: 30),

                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        loginUser(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Registration Text Button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationPage()),
                        );
                      },
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
