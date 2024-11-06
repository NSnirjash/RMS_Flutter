
class Food {
  int? id;
  String? name;
  double? price;
  String? category;
  bool? available;
  String? image;

  Food(
      {this.id,
        this.name,
        this.price,
        this.category,
        this.available,
        this.image});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    category = json['category'];
    available = json['available'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['category'] = this.category;
    data['available'] = this.available;
    data['image'] = this.image;
    return data;
  }
}