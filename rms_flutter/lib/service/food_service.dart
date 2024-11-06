import 'dart:convert';

import 'package:rms_flutter/model/food.dart';
import 'package:http/http.dart' as http;

class FoodService{
  final String apiUrl = "http://localhost:8090/api/food/view";

  Future<List<Food>> fetchFoods() async {
    final response = await http.get(Uri.parse(apiUrl));
    if(response.statusCode == 200 || response.statusCode == 201){
      final List<dynamic> foodJson = json.decode(response.body);
          return foodJson.map((json) => Food.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load foods");
    }
  }
}