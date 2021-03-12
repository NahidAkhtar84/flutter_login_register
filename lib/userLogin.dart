import 'dart:convert';

UserLogin userLoginFromJson(String str) => UserLogin.fromJson(json.decode(str));

String userLoginToJson(UserLogin data) => json.encode(data.toJson());

class UserLogin {
  UserLogin({
    this.mobile,
    this.password,
  });

  String mobile;
  String password;

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    mobile: json["mobile"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "mobile": mobile,
    "password": password,
  };
}