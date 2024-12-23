class UserModel {
  String name = "";
  String email = "";
  String? avatar;

  UserModel({required this.name, required this.email, this.avatar});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    return data;
  }

  @override
  String toString() {
    return 'UserModel{name: $name, email: $email, avatar: $avatar}';
  }
}
