import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  // Default to light theme
  bool isDarkTheme = false;

  // Method to toggle theme
  void _toggleTheme(bool value) {
    setState(() {
      isDarkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Theme Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: isDarkTheme ? Colors.black : Colors.deepPurple,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkTheme
              ? LinearGradient(
            colors: [Colors.black87, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
              : LinearGradient(
            colors: [Colors.purple.shade100, Colors.purple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Choose Your Theme',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme ? Colors.white : Colors.deepPurple.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            _buildThemeTile(
              context,
              'Light Theme',
              'A bright and clean theme.',
              Icons.wb_sunny,
              Colors.yellow,
              false,
            ),
            _buildThemeTile(
              context,
              'Dark Theme',
              'A sleek and modern dark theme.',
              Icons.nightlight_round,
              Colors.blueGrey,
              true,
            ),
            _buildThemeTile(
              context,
              'Blue Theme',
              'A calming blue theme with soft tones.',
              Icons.color_lens,
              Colors.blue,
              false,
            ),
            _buildThemeTile(
              context,
              'Red Theme',
              'A vibrant red theme with energy.',
              Icons.color_lens,
              Colors.red,
              false,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Current Theme: ${isDarkTheme ? "Dark Theme" : "Light Theme"}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDarkTheme ? Colors.white : Colors.deepPurple.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      bool isDark,
      ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
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
        trailing: Switch(
          value: isDarkTheme == isDark,
          onChanged: (bool value) {
            _toggleTheme(value);
          },
          activeColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
