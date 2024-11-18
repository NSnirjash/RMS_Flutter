

import 'package:flutter/material.dart';
import 'package:rms_flutter/page/AllFoodViewPage.dart';
import 'package:rms_flutter/page/AllTableViewPage.dart';
import 'package:rms_flutter/page/CreateOrderPage.dart';
import 'package:rms_flutter/page/CreateTableBookingPage.dart';
import 'package:rms_flutter/page/LoginPage.dart';

class Userpage extends StatelessWidget {
  const Userpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
        automaticallyImplyLeading: false, // Hides the back button
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, User!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.fastfood),
              label: Text('View Food'),
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AllFoodViewPage()),
                ); // Example logout: navigate back to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton.icon(
              icon: Icon(Icons.fastfood),
              label: Text('Order Food'),
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CreateOrderPage()),
                ); // Example logout: navigate back to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton.icon(
              icon: Icon(Icons.table_restaurant),
              label: Text('View Table'),
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTableBookingPage()),
                ); // Example logout: navigate back to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),


            ElevatedButton.icon(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
              onPressed: () {
                // Navigate to settings page
                print("Settings clicked");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Example logout: navigate back to login
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
