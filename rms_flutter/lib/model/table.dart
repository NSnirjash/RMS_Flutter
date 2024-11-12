
class TableModel {
  int? id;
  String? tableNumber;
  int? capacity;
  String? status;

  TableModel({this.id, this.tableNumber, this.capacity, this.status});

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableNumber = json['tableNumber'];
    capacity = json['capacity'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tableNumber'] = this.tableNumber;
    data['capacity'] = this.capacity;
    data['status'] = this.status;
    return data;
  }
}