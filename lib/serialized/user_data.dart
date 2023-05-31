class UserData {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? phoneLocale;
  String? profilePicture;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.phoneLocale,
    this.profilePicture,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    phoneLocale = json['phoneLocale'] as String?;
    profilePicture = json['profilePicture'] as String?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['phoneLocale'] = phoneLocale;
    data['profilePicture'] = profilePicture;
    return data;
  }
}
