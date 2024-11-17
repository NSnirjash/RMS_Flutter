import 'dart:convert';
import 'package:rms_flutter/model/TableBooking.dart';
import 'package:rms_flutter/model/table.dart';
import 'package:rms_flutter/service/AuthService.dart';
import 'package:http/http.dart' as http;

class TableBookingService {
  final String _baseUrl = 'http://localhost:8090/api';
  final AuthService _authService = AuthService();

  // Get Bearer token headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Fetch all tables
  Future<List<TableModel>> getAllTables() async {
    final response = await http.get(Uri.parse('$_baseUrl/table/view'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TableModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load tables');
    }
  }

  // Fetch all bookings
  Future<List<TableBooking>> getAllBookings() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/bookings/allbooking'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TableBooking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Fetch a single booking by ID
  Future<TableBooking> getBookingById(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/bookings/$id'), headers: headers);
    if (response.statusCode == 200) {
      return TableBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load booking');
    }
  }

  // Fetch bookings for a specific user
  Future<List<TableBooking>> getUserBookings(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/bookings/user/$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TableBooking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load user bookings');
    }
  }

  // Create a new booking
  Future<TableBooking> createBooking(TableBooking booking) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings/create'),
      headers: headers,
      body: json.encode(booking.toJson()),
    );
    if (response.statusCode == 200) {
      return TableBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create booking');
    }
  }

  // Update a booking
  Future<TableBooking> updateBooking(int bookingId, int userId, int tableId) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/bookings/update/$bookingId?userId=$userId&tableId=$tableId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return TableBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update booking');
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(int bookingId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/bookings/cancel/$bookingId'), headers: {
      'Content-Type': 'text/plain'
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to cancel booking');
    }
  }

  // Approve a booking
  Future<TableBooking> approveBooking(int bookingId, int adminId) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/approvals/approve/$bookingId?adminId=$adminId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return TableBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to approve booking');
    }
  }

  // Reject a booking
  Future<TableBooking> rejectBooking(int bookingId, int adminId) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/approvals/reject/$bookingId?adminId=$adminId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return TableBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to reject booking');
    }
  }

  // Free a table
  Future<TableBooking> freeTable(int bookingId, int adminId) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/approvals/free/$bookingId?adminId=$adminId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return TableBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to free the table');
    }
  }

  // Fetch all pending bookings
  Future<List<TableBooking>> getPendingBookings() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/bookings/pending'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TableBooking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load pending bookings');
    }
  }
}