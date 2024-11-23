import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rms_flutter/model/Bill.dart';
import 'package:rms_flutter/service/AuthService.dart';


class BillService {
  final String apiUrl = 'http://localhost:8090/api/bills';
  final AuthService authService = AuthService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('Authorization token is required.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<BillModel> createBill(int orderId, int adminId) async {
    if (orderId <= 0) {
      throw Exception('Order ID must be a positive number.');
    }
    if (adminId <= 0) {
      throw Exception('Admin ID must be a positive number.');
    }

    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/create?orderId=$orderId&adminId=$adminId');

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response);
      throw Exception('Failed to create bill');
    }
  }

  Future<BillModel> payBill(int billId) async {
    if (billId <= 0) {
      throw Exception('Bill ID must be a positive number.');
    }

    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/pay/$billId');

    final response = await http.put(url, headers: headers);

    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response);
      throw Exception('Failed to pay bill');
    }
  }

  Future<BillModel> confirmBill(int billId, int adminId) async {
    if (billId <= 0) {
      throw Exception('Bill ID must be a positive number.');
    }
    if (adminId <= 0) {
      throw Exception('Admin ID must be a positive number.');
    }

    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/confirm/$billId?adminId=$adminId');

    final response = await http.put(url, headers: headers);

    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response);
      throw Exception('Failed to confirm bill');
    }
  }

  Future<BillModel> getBillById(int billId) async {
    if (billId <= 0) {
      throw Exception('Bill ID must be a positive number.');
    }

    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/$billId');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response);
      throw Exception('Failed to fetch bill');
    }
  }

  void _handleError(http.Response response) {
    if (response.statusCode == 403) {
      throw Exception('403 Forbidden: Access denied.');
    } else {
      throw Exception(
          'Error ${response.statusCode}: ${response.reasonPhrase}\n${response.body}');
    }
  }
}