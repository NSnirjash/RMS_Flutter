import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rms_flutter/model/Order.dart';
import 'package:rms_flutter/service/AuthService.dart';


class OrderService {
  final String apiUrl = 'http://localhost:8090/api/order';
  final AuthService authService = AuthService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await authService.getToken(); // Assumes authService has a method to get token
    if (token == null) {
      throw Exception("Authorization token not found.");
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/create');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(order.toJson()), // Assumes OrderModel has a toJson method
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return OrderModel.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response);
      throw Exception('Failed to create order'); // Add a throw statement after handling the error
    }
  }

  Future<List<OrderModel>> getAllOrders(int userId) async {
    final url = Uri.parse('$apiUrl/all?userId=$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      _handleError(response);
      throw Exception('Failed to fetch orders'); // Add a throw statement after handling the error
    }
  }


  Future<OrderModel> getOrderById(int id) async {
    final url = Uri.parse('$apiUrl/$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return OrderModel.fromJson(jsonDecode(response.body));
    } else {
      _handleError(response);
      throw Exception('Failed to fetch the order'); // Add a throw statement after handling the error
    }
  }


  Future<OrderModel> getOrderByBillId(int billId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/getOrderByBillId?billId=$billId'),
    );

    if (response.statusCode == 200) {
      return OrderModel.fromJson(json.decode(response.body));
    } else {
      _handleError(response);
      throw Exception('Failed to load order');
    }
  }


  Future<void> updateOrderStatus(int id, String status) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/update/$id?status=$status');

    final response = await http.put(url, headers: headers);

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> approveOrder(int id, int adminId, int staffId) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/approve/$id?adminId=$adminId&staffId=$staffId');

    final response = await http.put(url, headers: headers);

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> serveOrder(int id) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/delete/$id');

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> rejectOrder(int id, int adminId) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/reject/$id?adminId=$adminId');

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  Future<void> deleteOrder(int id) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$apiUrl/delete/$id');

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      _handleError(response);
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