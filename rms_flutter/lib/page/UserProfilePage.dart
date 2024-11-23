import 'package:flutter/material.dart';
import 'package:rms_flutter/model/user.dart';
import 'package:rms_flutter/service/AuthService.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User?> _user;

  @override
  void initState() {
    super.initState();
    _user = AuthService().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<User?>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No user data found.'));
          }

          final user = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Profile Image or Icon
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: user.image == null || user.image!.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.deepPurpleAccent,
                          )
                        : Image.network(
                            user.image!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // User Details
                _buildUserInfoTile('Name', user.name, Colors.teal),
                _buildUserInfoTile('Email', user.email, Colors.teal),
                _buildUserInfoTile('Phone', user.phone, Colors.teal),
                _buildUserInfoTile('Address', user.address, Colors.teal),
                _buildUserInfoTile('Role', user.role, Colors.teal),
                _buildUserInfoTile('Username', user.username, Colors.teal),
                _buildUserInfoTile(
                  'Account Status',
                  user.active! ? 'Active' : 'Inactive',
                  user.active! ? Colors.teal : Colors.red,
                ),
                const SizedBox(height: 24),

                // Account Info Section
                // _buildSectionTitle('Account Information', Colors.teal),
                // _buildUserInfoTile('Account Non-Expired', user.accountNonExpired! ? 'Yes' : 'No', Colors.teal),
                // _buildUserInfoTile('Credentials Non-Expired', user.credentialsNonExpired! ? 'Yes' : 'No', Colors.teal),
                // _buildUserInfoTile('Account Non-Locked', user.accountNonLocked! ? 'Yes' : 'No', Colors.teal),
                // const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your update profile logic here
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: Text(
                        'Update Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your logout logic here
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoTile(String label, String? value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
