

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  String? address;
  String? phone;
  String? image;
  bool? active;
  String? role;
  bool? enabled;
  String? username;
  bool? accountNonExpired;
  bool? credentialsNonExpired;
  bool? accountNonLocked;

  User(
      {this.id,
        this.name,
        this.email,
        this.password,
        this.address,
        this.phone,
        this.image,
        this.active,
        this.role,
        this.enabled,
        this.username,
        this.accountNonExpired,
        this.credentialsNonExpired,
        this.accountNonLocked});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    phone = json['phone'];
    image = json['image'];
    active = json['active'];
    role = json['role'];
    enabled = json['enabled'];
    username = json['username'];
    accountNonExpired = json['accountNonExpired'];
    credentialsNonExpired = json['credentialsNonExpired'];
    accountNonLocked = json['accountNonLocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['active'] = this.active;
    data['role'] = this.role;
    data['enabled'] = this.enabled;
    data['username'] = this.username;
    data['accountNonExpired'] = this.accountNonExpired;
    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['accountNonLocked'] = this.accountNonLocked;
    return data;
  }
}
