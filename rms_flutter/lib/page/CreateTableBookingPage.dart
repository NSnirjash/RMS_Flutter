import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:rms_flutter/model/TableBooking.dart';
import 'package:rms_flutter/model/table.dart';
import 'package:rms_flutter/page/UserPage.dart';
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
  late Future<List<TableBooking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _tablesFuture = _tableBookingService.getAllTables();
    _bookingsFuture = _tableBookingService.getAllBookings();
  }

  Future<void> _bookTable(TableModel table) async {
    try {
      final currentUser = await AuthService().getCurrentUser();

      await _tableBookingService.createBooking(
        TableBooking(
          tables: table,
          status: "PENDING",
          bookingDate: DateTime.now(),
          bookedBy: currentUser,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table ${table.tableNumber} booking request is sent To Admin. Please Wait for Admins approval')),
      );

      setState(() {
        _loadData();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book table: $error')),
      );
    }
  }

  Future<void> _cancelBooking(TableBooking booking) async {
    try {
      // Ensure booking.id is not null before proceeding
      if (booking.id == null) {
        throw Exception("Booking ID is null.");
      }

      // Call the cancelBooking method with a non-nullable ID
      await _tableBookingService.cancelBooking(booking.id!); // Use the '!' operator to assert non-null

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking canceled successfully!')),
      );

      setState(() {
        _loadData();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserPage()),
            );
          },
        ),
        title: Center(
          child: Text(
            'Create Table Booking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.indigo.shade600,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade100, Colors.tealAccent.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          FutureBuilder<List<TableModel>>(
            future: _tablesFuture,
            builder: (context, tableSnapshot) {
              if (tableSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (tableSnapshot.hasError) {
                return Center(child: Text('Error: ${tableSnapshot.error}'));
              }

              final tables = tableSnapshot.data ?? [];

              return FutureBuilder<List<TableBooking>>(
                future: _bookingsFuture,
                builder: (context, bookingSnapshot) {
                  if (bookingSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (bookingSnapshot.hasError) {
                    return Center(child: Text('Error: ${bookingSnapshot.error}'));
                  }

                  final bookings = bookingSnapshot.data ?? [];
                  final tableStatuses = _mapTableStatuses(tables, bookings);

                  return ListView.builder(
                    itemCount: tables.length,
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      final status = tableStatuses[table.id] ?? "AVAILABLE";
                      final isAvailable = status == "AVAILABLE";
                      final booking = bookings.firstWhere(
                            (booking) => booking.tables?.id == table.id && booking.status == "PENDING",
                        orElse: () => TableBooking(status: "AVAILABLE"), // Default to AVAILABLE if no pending booking
                      );

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.greenAccent.shade200 : Colors.greenAccent.shade400,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              'Table Number: ${table.tableNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Capacity: ${table.capacity}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  'Status: $status',
                                  style: TextStyle(
                                    color: status == "PENDING"
                                        ? Colors.yellow
                                        : (isAvailable ? Colors.indigo : Colors.red),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: isAvailable
                                ? ElevatedButton(
                              onPressed: () => _bookTable(table),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Book Now',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                                : booking.status == "PENDING"
                                ? ElevatedButton(
                              onPressed: () => _cancelBooking(booking),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel Booking',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Map<int, String> _mapTableStatuses(List<TableModel> tables, List<TableBooking> bookings) {
    final statusMap = <int, String>{};

    for (var booking in bookings) {
      final tableId = booking.tables?.id;
      if (tableId != null) {
        final bookingStatus = booking.status ?? "UNKNOWN";

        if (bookingStatus == "FREED" || bookingStatus == "REJECTED") {
          statusMap[tableId] = "AVAILABLE";
        } else {
          statusMap[tableId] = bookingStatus;
        }
      }
    }

    for (var table in tables) {
      final tableId = table.id;
      if (tableId != null && !statusMap.containsKey(tableId)) {
        statusMap[tableId] = "AVAILABLE";
      }
    }

    return statusMap;
  }
}


