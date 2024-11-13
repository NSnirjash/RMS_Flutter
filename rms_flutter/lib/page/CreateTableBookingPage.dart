import 'package:flutter/material.dart';
import 'package:rms_flutter/model/TableBooking.dart';
import 'package:rms_flutter/model/table.dart';
import 'package:rms_flutter/model/user.dart';
import 'package:rms_flutter/service/AuthService.dart';
import 'package:rms_flutter/service/TableBookingService.dart';

class CreateTableBookingPage extends StatefulWidget {
  const CreateTableBookingPage({super.key});

  @override
  State<CreateTableBookingPage> createState() => _CreateTableBookingPageState();
}

class _CreateTableBookingPageState extends State<CreateTableBookingPage> {

  final TableBookingService _tableBookingService = TableBookingService();
  late Future<List<TableModel>> _tablesFuture;

  @override
  void initState() {
    super.initState();
    _tablesFuture = _tableBookingService.getAllTables();
  }

  void _bookTable(TableModel table) async {
    try {
      final currentUser = await AuthService().getCurrentUser();

      // final currentUserData = await AuthService().getCurrentUser();
      // if (currentUserData != null) {
      //   final currentUser = User.fromJson(currentUserData);

      final booking = await _tableBookingService.createBooking(
        TableBooking(
          tables: table,
          status: "PENDING",
          bookingDate: DateTime.now(),
          bookedBy: currentUser, // Replace with current user details if needed
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table ${table.id} booked successfully!')),
      );
      setState(() {
        _tablesFuture = _tableBookingService.getAllTables(); // Refresh table list
      });
    }
      // else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Error: User not found.')),
      //   );
      // }
    // }
    catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book table: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Create Table Booking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<TableModel>>(
        future: _tablesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tables available.'));
          }

          final tables = snapshot.data!;
          return ListView.builder(
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              final isAvailable = table.status == "AVAILABLE";
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text('Table ID: ${table.id}'),
                  subtitle: Text('Status: ${table.status}'),
                  trailing: ElevatedButton(
                    onPressed: isAvailable ? () => _bookTable(table) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAvailable ? Colors.green : Colors.grey,
                    ),
                    child: Text(isAvailable ? 'Book Now' : 'Unavailable'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
