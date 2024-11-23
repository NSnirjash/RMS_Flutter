import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
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
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationTile(
              title: 'New Menu Added!',
              description: 'Check out the new dishes available for the month.',
              time: '2 hours ago',
              isRead: false,
              onTap: () {
                // Handle tap (e.g., navigate to Menu Page)
                print('Navigating to Menu Page...');
              },
            ),
            _buildNotificationTile(
              title: 'Table Reservation Reminder',
              description: 'You have a table reserved at 7:00 PM today.',
              time: '5 hours ago',
              isRead: true,
              onTap: () {
                // Handle tap (e.g., navigate to Reservation Page)
                print('Navigating to Reservation Page...');
              },
            ),
            _buildNotificationTile(
              title: 'New Review Received!',
              description: 'You got a 5-star review from a customer.',
              time: '1 day ago',
              isRead: false,
              onTap: () {
                // Handle tap (e.g., navigate to Reviews Page)
                print('Navigating to Reviews Page...');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String description,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        tileColor: isRead ? Colors.white : Colors.deepPurple.shade50,
        leading: Icon(
          isRead ? Icons.check_circle : Icons.notifications,
          color: isRead ? Colors.green : Colors.deepPurple,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
