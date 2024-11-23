

import 'package:flutter/material.dart';

class Settingspage extends StatelessWidget {
  const Settingspage({super.key});

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
              onTap: () => print('Navigate to Profile Settings'),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              color: Colors.orange,
              onTap: () => print('Navigate to Notification Settings'),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.palette,
              title: 'Theme',
              subtitle: 'Customize app appearance',
              color: Colors.pink,
              onTap: () => print('Navigate to Theme Settings'),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.lock,
              title: 'Privacy & Security',
              subtitle: 'Adjust your privacy settings',
              color: Colors.teal,
              onTap: () => print('Navigate to Privacy Settings'),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Choose your preferred language',
              color: Colors.purple,
              onTap: () => print('Navigate to Language Settings'),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.info,
              title: 'About',
              subtitle: 'Learn more about this app',
              color: Colors.green,
              onTap: () => print('Navigate to About Page'),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help or contact support',
              color: Colors.redAccent,
              onTap: () => print('Navigate to Help Page'),
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
