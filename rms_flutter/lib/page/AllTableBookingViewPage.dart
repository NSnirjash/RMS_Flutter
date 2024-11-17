import 'package:flutter/material.dart';
import 'package:rms_flutter/model/TableBooking.dart';
import 'package:rms_flutter/page/AdminPage.dart';
import 'package:rms_flutter/page/BookingDetailsPage.dart';
import 'package:rms_flutter/service/AuthService.dart';
import 'package:rms_flutter/service/TableBookingService.dart';

class AllTableBookingViewPage extends StatefulWidget {
  const AllTableBookingViewPage({super.key});

  @override
  State<AllTableBookingViewPage> createState() => _AllTableBookingViewPageState();
}

class _AllTableBookingViewPageState extends State<AllTableBookingViewPage> {
  final TableBookingService _tableBookingService = TableBookingService();
  late Future<List<TableBooking>> _bookingsFuture;

  int? userID;
  final AuthService authService = AuthService();

  // Dropdown value to toggle between all bookings and pending bookings
  String _selectedView = 'All Table Booking';

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _tableBookingService.getAllBookings(); // Initial fetch for all bookings
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final user = await authService.getCurrentUser();
      setState(() {
        userID = user?.id; // Assign user ID or null
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch admin ID: $error')),
      );
    }
  }

  void _onDropdownChanged(String? newValue) {
    setState(() {
      _selectedView = newValue!;
      // Fetch the appropriate bookings based on the selection
      if (_selectedView == 'All Table Bookings') {
        _bookingsFuture = _tableBookingService.getAllBookings();
      } else if (_selectedView == 'New Booking Request') {
        _bookingsFuture = _tableBookingService.getPendingBookings();
      }
    });
  }

  void _approveBooking(int bookingId) async {
    try {
      if (userID == null) {
        throw Exception('Admin ID is not initialized.');
      }
      await _tableBookingService.approveBooking(bookingId, userID!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking $bookingId approved successfully!')),
      );
      setState(() {
        _bookingsFuture = _tableBookingService.getAllBookings();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve booking: $error')),
      );
    }
  }

  void _rejectBooking(int bookingId) async {
    try {
      if (userID == null) {
        throw Exception('Admin ID is not initialized.');
      }
      await _tableBookingService.rejectBooking(bookingId, userID!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking $bookingId rejected successfully!')),
      );
      setState(() {
        _bookingsFuture = _tableBookingService.getAllBookings();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject booking: $error')),
      );
    }
  }

  void _freeTable(int bookingId) async {
    try {
      if (userID == null) {
        throw Exception('Admin ID is not initialized.');
      }
      await _tableBookingService.freeTable(bookingId, userID!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table freed for booking $bookingId!')),
      );
      setState(() {
        _bookingsFuture = _tableBookingService.getAllBookings();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to free table: $error')),
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
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          },
        ),
        title: Center(
          child: Text(
            'Table Bookings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.teal.shade800,
        elevation: 8,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Dropdown to switch between All Table Booking and New Booking Request
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownButton<String>(
                value: _selectedView,
                onChanged: _onDropdownChanged,
                items: <String>['All Table Booking', 'New Booking Request']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16, color: Colors.teal.shade800),
                    ),
                  );
                }).toList(),
                icon: Icon(Icons.filter_list),
                iconSize: 30,
                elevation: 16,
                style: TextStyle(color: Colors.teal.shade800),
                dropdownColor: Colors.white,
                isExpanded: true,
              ),
            ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        elevation: 8,
                        color: Colors.white,
                        shadowColor: Colors.black.withOpacity(0.3),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            'Booking ID: ${booking.id}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal.shade700),
                          ),
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
                          trailing: booking.status == 'PENDING' || booking.status == 'UPDATED'
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () => _approveBooking(booking.id!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Approve',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _rejectBooking(booking.id!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Reject',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          )
                              : booking.status == 'APPROVED'
                              ? ElevatedButton(
                            onPressed: () => _freeTable(booking.id!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Free Table',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black
                              ),
                            ),
                          )
                              : Icon(Icons.arrow_forward_ios),
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
          ],
        ),
      ),
    );
  }
}
