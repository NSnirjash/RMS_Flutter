import 'package:flutter/material.dart';
import 'package:rms_flutter/model/TableBooking.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/page/BookingDetailsPage.dart';
import 'package:rms_flutter/service/TableBookingService.dart';

class AllTableBookingViewPage extends StatefulWidget {
  const AllTableBookingViewPage({super.key});

  @override
  State<AllTableBookingViewPage> createState() => _AllTableBookingViewPageState();
}

class _AllTableBookingViewPageState extends State<AllTableBookingViewPage> {

  final TableBookingService _tableBookingService = TableBookingService();
  late Future<List<TableBooking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _tableBookingService.getAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'All Table Bookings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<TableBooking>>(
              future: _bookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No bookings available.'));
                }

                final bookings = snapshot.data!;
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text('Booking ID: ${booking.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${booking.status ?? 'N/A'}'),
                            Text('Booking Date: ${booking.bookingDate ?? 'N/A'}'),
                            if (booking.bookedBy != null)
                              Text('Booked By: ${booking.bookedBy!.name ?? 'Unknown'}'),
                            if (booking.approvedBy != null)
                              Text('Approved By: ${booking.approvedBy!.name ?? 'Unknown'}'),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsPage(booking: booking),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPage()),
                  );
                },
                child: Text('Back to Previous Page'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
