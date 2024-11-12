import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:rms_flutter/model/table.dart';
import 'package:rms_flutter/service/AuthService.dart';



class TableService {
  final Dio _dio = Dio();
  final AuthService authService = AuthService();
  final String apiUrl = 'http://localhost:8090/api/table';

  // Fetch all tables
  Future<List<TableModel>> fetchTables() async {
    final response = await http.get(Uri.parse('$apiUrl/view'));
    if (response.statusCode == 200) {
      final List<dynamic> tableJson = json.decode(response.body);
      return tableJson.map((json) => TableModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tables');
    }
  }

  // Create a new table
  Future<TableModel?> createTable(TableModel table) async {
    final token = await authService.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/save'),
        headers: headers,
        body: jsonEncode(table.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TableModel.fromJson(json.decode(response.body));
      } else {
        print('Error creating table: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating table: $e');
      return null;
    }
  }

  // Update a table by ID
  Future<TableModel?> updateTable(TableModel table, int id) async {
    final token = await authService.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/update?id=$id'),
        headers: headers,
        body: jsonEncode(table.toJson()),
      );

      if (response.statusCode == 200) {
        return TableModel.fromJson(json.decode(response.body));
      } else {
        print('Error updating table: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating table: $e');
      return null;
    }
  }

  // Delete a table by ID
  Future<bool> deleteTable(int id) async {
    final token = await authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/delete/$id'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting table: $e');
      return false;
    }
  }

  // Find a table by ID
  Future<TableModel?> findTableById(int id) async {
    final token = await authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/view/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return TableModel.fromJson(json.decode(response.body));
      } else {
        print('Error finding table by ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error finding table by ID: $e');
      return null;
    }
  }
}
