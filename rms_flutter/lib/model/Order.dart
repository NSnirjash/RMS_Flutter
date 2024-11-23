

import 'package:rms_flutter/model/Bill.dart';
import 'package:rms_flutter/model/OrderItem.dart';
import 'package:rms_flutter/model/user.dart';

class OrderModel {
  int? id;
  User? user;
  List<OrderItems>? orderItems;
  String? status;
  double? totalPrice;
  User? admin;
  User? staff;
  Null? notes;
  BillModel? bill;

  OrderModel(
      {this.id,
        this.user,
        this.orderItems,
        this.status,
        this.totalPrice,
        this.admin,
        this.staff,
        this.notes,
        this.bill});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    status = json['status'];
    totalPrice = json['totalPrice'];
    admin = json['admin'] != null ? new User.fromJson(json['admin']) : null;
    staff = json['staff'] != null ? new User.fromJson(json['staff']) : null;
    notes = json['notes'];
    bill = json['bill'] != null ? BillModel.fromJson(json['bill']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['totalPrice'] = this.totalPrice;
    if (this.admin != null) {
      data['admin'] = this.admin!.toJson();
    }
    if (this.staff != null) {
      data['staff'] = this.staff!.toJson();
    }
    data['notes'] = this.notes;
    if (this.bill != null) {
      data['bill'] = this.bill!.toJson();
    }
    return data;
  }
}