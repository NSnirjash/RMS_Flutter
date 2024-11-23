import 'package:flutter/material.dart';
import 'package:rms_flutter/page/AboutPage.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/page/HelpSupportPage.dart';
import 'package:rms_flutter/page/LanguagePage.dart';
import 'package:rms_flutter/page/NotificationPage.dart';
import 'package:rms_flutter/page/PrivacySecurityPage.dart';
import 'package:rms_flutter/page/ThemPage.dart';
import 'package:rms_flutter/page/UserPage.dart';
import 'package:rms_flutter/page/UserProfilePage.dart';
import 'package:rms_flutter/service/AuthService.dart';

class Settingspage extends StatelessWidget {
  Settingspage({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            // Fetch the current user
            final user = await _authService.getCurrentUser();

            // Check if the user is null before accessing the role
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User not found! Please log in again.')),
              );
              return;
            }
            // Navigate based on the user's role
            if (user.role == 'ADMIN') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            } else if (user.role == 'USER') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserPage()),
              );
            } else {
              // Handle unexpected roles
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Unknown user role!')),
              );
            }
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSettingsCard(
              context,
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'View and edit your profile',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage()),
              ),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              ),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.palette,
              title: 'Theme',
              subtitle: 'Customize app appearance',
              color: Colors.pink,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemePage()),
              ),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.lock,
              title: 'Privacy & Security',
              subtitle: 'Adjust your privacy settings',
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacySecurityPage()),
              ),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Choose your preferred language',
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguagePage()),
              ),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.info,
              title: 'About',
              subtitle: 'Learn more about this app',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              ),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help or contact support',
              color: Colors.redAccent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        onTap: onTap,
      ),
    );
  }
}
