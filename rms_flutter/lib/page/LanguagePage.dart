import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Language',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
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
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Choose Your Language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildLanguageTile(context, 'English', 'en', Colors.blue),
                  _buildLanguageTile(context, 'Español (Spanish)', 'es', Colors.red),
                  _buildLanguageTile(context, 'Français (French)', 'fr', Colors.cyan),
                  _buildLanguageTile(context, 'Deutsch (German)', 'de', Colors.amber),
                  _buildLanguageTile(context, 'বাংলা (Bangla)', 'bn', Colors.deepPurple),
                  _buildLanguageTile(context, '中文 (Chinese)', 'zh', Colors.green),
                  _buildLanguageTile(context, 'हिन्दी (Hindi)', 'hi', Colors.deepOrange),
                  _buildLanguageTile(context, 'عربي (Arabic)', 'ar', Colors.teal),
                  _buildLanguageTile(context, 'Русский (Russian)', 'ru', Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Restart the app for changes to take effect.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, String language, String code, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            code.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        title: Text(
          language,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$language selected!'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
