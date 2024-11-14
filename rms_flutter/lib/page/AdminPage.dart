import 'package:flutter/material.dart';
import 'package:rms_flutter/page/AddFoodPage.dart';
import 'package:rms_flutter/page/AddTablePage.dart';
import 'package:rms_flutter/page/AllFoodViewPage.dart';
import 'package:rms_flutter/page/AllTableBookingViewPage.dart';
import 'package:rms_flutter/page/AllTableViewPage.dart';
import 'package:rms_flutter/page/LoginPage.dart';
import 'package:rms_flutter/service/AuthService.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String userName = '';
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Fetch the current user's name from AuthService
  Future<void> _fetchUserName() async {
    final user = await authService.getCurrentUser();
    setState(() {
      userName = user?.name ?? 'Admin'; // Use 'Admin' as fallback
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, $userName!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade800,
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
                      color: Colors.deepPurple,
                      onTap: () => print("View Users clicked"),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.add,
                      label: 'Add Food',
                      color: Colors.green,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AddFoodPage()),
                      ),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.fastfood,
                      label: 'Delete or Update Food',
                      color: Colors.orange,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllFoodViewPage()),
                      ),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.add,
                      label: 'Add Table',
                      color: Colors.pink,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AddTablePage()),
                      ),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.table_restaurant,
                      label: 'Delete or Update Table',
                      color: Colors.amber,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllTableViewPage()),
                      ),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.table_restaurant,
                      label: 'View Booking Table',
                      color: Colors.indigo,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllTableBookingViewPage()),
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
        color: color.withOpacity(0.1),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.5), width: 1),
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
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
