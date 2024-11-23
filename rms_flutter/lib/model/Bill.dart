

import 'package:rms_flutter/model/user.dart';

class BillModel {
  int? id;
  int? totalAmount;
  String? billDate;
  Null? paymentMethod;
  String? status;
  User? paidBy;
  User? receivedBy;

  BillModel(
      {this.id,
        this.totalAmount,
        this.billDate,
        this.paymentMethod,
        this.status,
        this.paidBy,
        this.receivedBy});

  BillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['totalAmount'];
    billDate = json['billDate'];
    paymentMethod = json['paymentMethod'];
    status = json['status'];
    paidBy =
    json['paidBy'] != null ? new User.fromJson(json['paidBy']) : null;
    receivedBy = json['receivedBy'] != null
        ? new User.fromJson(json['receivedBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['totalAmount'] = this.totalAmount;
    data['billDate'] = this.billDate;
    data['paymentMethod'] = this.paymentMethod;
    data['status'] = this.status;
    if (this.paidBy != null) {
      data['paidBy'] = this.paidBy!.toJson();
    }
    if (this.receivedBy != null) {
      data['receivedBy'] = this.receivedBy!.toJson();
    }
    return data;
  }
}
