import 'package:flutter/material.dart';
import 'package:rms_flutter/model/TableBooking.dart';

class BookingDetailsPage extends StatelessWidget {

  final TableBooking booking;

  BookingDetailsPage({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Booking Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${booking.id}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Status: ${booking.status ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Booking Date: ${booking.bookingDate ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Approval Date: ${booking.approvalDate ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            if (booking.bookedBy != null) ...[
              Text('Booked By:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('  Name: ${booking.bookedBy!.name ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
              Text('  Email: ${booking.bookedBy!.email ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
              Text('  Phone: ${booking.bookedBy!.phone ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
            ],
            if (booking.approvedBy != null) ...[
              Text('Approved By:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('  Name: ${booking.approvedBy!.name ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
              Text('  Email: ${booking.approvedBy!.email ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
              Text('  Phone: ${booking.approvedBy!.phone ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
            ],
            if (booking.tables != null) ...[
              Text('Table Details:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('  Table ID: ${booking.tables!.id ?? 'N/A'}', style: TextStyle(fontSize: 16)),
              Text('  Table Number: ${booking.tables!.tableNumber ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            ],
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Previous Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
