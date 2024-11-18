

import 'package:rms_flutter/model/food.dart';

class OrderItems {
  int? id;
  Food? food;
  int? quantity;

  OrderItems({this.id, this.food, this.quantity});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    food = json['food'] != null ? new Food.fromJson(json['food']) : null;
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.food != null) {
      data['food'] = this.food!.toJson();
    }
    data['quantity'] = this.quantity;
    return data;
  }
}