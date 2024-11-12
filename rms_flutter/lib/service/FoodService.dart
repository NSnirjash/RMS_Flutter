import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rms_flutter/model/food.dart';
import 'package:http/http.dart' as http;
import 'package:rms_flutter/service/AuthService.dart';

class FoodService{

  final Dio _dio = Dio();

  final AuthService authService = AuthService();


  final String apiUrl = "http://localhost:8090/api/food/view";
  final String apiUrl2 = "http://localhost:8090/api/food/";

  Future<List<Food>> fetchFoods() async {
    final response = await http.get(Uri.parse(apiUrl));
    if(response.statusCode == 200 || response.statusCode == 201){
      final List<dynamic> foodJson = json.decode(response.body);
          return foodJson.map((json) => Food.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load foods");
    }
  }


  Future<Food?> createFood(Food food, XFile? image) async {
    final formData = FormData();

    formData.fields.add(MapEntry('food', jsonEncode(food.toJson())));

    if (image != null) {
      final bytes = await image.readAsBytes();
      formData.files.add(MapEntry('image', MultipartFile.fromBytes(
        bytes,
        filename: image.name,
      )));
    }

    final token = await authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await _dio.post(
        '${apiUrl2}save',
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Food.fromJson(data); // Parse response data to Hotel object
      } else {
        print('Error creating food: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      print('Error creating food: ${e.message}');
      return null;
    }
  }

}