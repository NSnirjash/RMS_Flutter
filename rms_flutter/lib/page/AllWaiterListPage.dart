import 'package:flutter/material.dart';
import 'package:rms_flutter/model/user.dart';
import 'package:rms_flutter/page/UserListPage.dart';
import 'package:rms_flutter/service/AuthService.dart';

class AllWaiterListPage extends StatefulWidget {
  const AllWaiterListPage({super.key});

  @override
  State<AllWaiterListPage> createState() => _AllWaiterListPageState();
}

class _AllWaiterListPageState extends State<AllWaiterListPage> {

  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = AuthService().getAllWaiters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Customer List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Userlistpage()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade50, Colors.lightBlueAccent.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<User>>(
          future: _users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No customers found.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final users = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserCard(user);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 10,
      shadowColor: Colors.orangeAccent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black26, Colors.blueAccent.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserAvatar(user),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'N/A',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    _buildUserInfoRow('Email', user.email),
                    _buildUserInfoRow('Phone', user.phone),
                    _buildUserInfoRow('Role', user.role),
                    _buildUserInfoRow(
                      'Status',
                      user.active == true ? 'Active' : 'Inactive',
                      user.active == true
                          ? Colors.lightGreenAccent
                          : Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(User user) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.black45,
      child: user.image != null && user.image!.isNotEmpty
          ? ClipOval(
        child: Image.network(
          user.image!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      )
          : const Icon(
        Icons.person,
        color: Colors.red,
        size: 30,
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String? value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
