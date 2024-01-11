import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  final User? user;
  final String? accessToken;

  LoginResponseModel({
    this.user,
    this.accessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "access_token": accessToken,
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final dynamic phone;
  final List<dynamic>? aclGroups;
  final List<dynamic>? permissions;
  final List<dynamic>? addresses;
  final dynamic point;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.aclGroups,
    this.permissions,
    this.addresses,
    this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phone: json["phone"],
    aclGroups: json["aclGroups"] == null ? [] : List<dynamic>.from(json["aclGroups"]!.map((x) => x)),
    permissions: json["permissions"] == null ? [] : List<dynamic>.from(json["permissions"]!.map((x) => x)),
    addresses: json["addresses"] == null ? [] : List<dynamic>.from(json["addresses"]!.map((x) => x)),
    point: json["point"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone": phone,
    "aclGroups": aclGroups == null ? [] : List<dynamic>.from(aclGroups!.map((x) => x)),
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
    "addresses": addresses == null ? [] : List<dynamic>.from(addresses!.map((x) => x)),
    "point": point,
  };
}
