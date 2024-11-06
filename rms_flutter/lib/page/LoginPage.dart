import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:rms_flutter/page/AllFoodViewPage.dart';
import 'package:rms_flutter/page/HomePage.dart';
import 'package:rms_flutter/page/RegistrationPage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = new FlutterSecureStorage();

  Future<void> loginUser(BuildContext context) async {
    final url = Uri.parse('http://localhost:8090/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.text, 'password': password.text}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      // Verify response data structure
      if (responseData == null || !responseData.containsKey('token') || responseData['token'] == null) {
        print('Token not found in the response or is null');
        return;
      }

      final token = responseData['token'];
      if (token is String) {
        try {
          Map<String, dynamic> payload = Jwt.parseJwt(token);

          // Check for sub and role in the payload
          String? sub = payload['sub'];
          String? role = payload['role'];

          if (sub == null || role == null) {
            print('Token payload missing "sub" or "role" fields');
            return;
          }

          await storage.write(key: 'token', value: token);
          await storage.write(key: 'sub', value: sub);
          await storage.write(key: 'role', value: role);

          print('Login successful. Sub: $sub, Role: $role');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllFoodViewPage()),
          );
        } catch (e) {
          print('Error parsing token: $e');
        }
      } else {
        print('Token is not a valid string');
      }
    } else {
      print('Login failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, right: 400, left: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Use Email and Password",
              style: TextStyle(
                fontSize: 40,
                color: Colors.blue,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            TextField(
              controller: email,
              decoration: InputDecoration(
                label: Text("Email"),
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller: password,
              decoration: InputDecoration(
                label: Text("Paassword"),
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.password),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {
                loginUser(context);
              },
              child: Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),

            SizedBox(height: 20),

            // Login Text Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text(
                'Registration',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}