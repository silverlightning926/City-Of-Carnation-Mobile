class UserData {
  String? uid;
  String? name;
  String? email;
  String? phone;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.phone,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
