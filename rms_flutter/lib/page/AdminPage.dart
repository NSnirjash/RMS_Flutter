

import 'package:flutter/material.dart';
import 'package:rms_flutter/page/AddFoodPage.dart';
import 'package:rms_flutter/page/AddTablePage.dart';
import 'package:rms_flutter/page/AllFoodViewPage.dart';
import 'package:rms_flutter/page/AllTableViewPage.dart';
import 'package:rms_flutter/page/LoginPage.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        automaticallyImplyLeading: false, // Hides the back button
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.people,
                    label: 'View Users',
                    color: Colors.deepPurpleAccent,
                    onTap: () => print("View Users clicked"),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.hotel,
                    label: 'Manage Hotels',
                    color: Colors.lightBlueAccent,
                    onTap: () => print("Manage Hotels clicked"),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.add,
                    label: 'Add Food',
                    color: Colors.greenAccent,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddFoodPage()),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.fastfood,
                    label: 'Delete or Update Food',
                    color: Colors.orangeAccent,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AllFoodViewPage()),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.add,
                    label: 'Add Table',
                    color: Colors.pinkAccent,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddTablePage()),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.table_restaurant,
                    label: 'Delete or Update Table',
                    color: Colors.amberAccent,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AllTableViewPage()),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.settings,
                    label: 'Settings',
                    color: Colors.blueGrey,
                    onTap: () => print("Settings clicked"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.6), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color,
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
