import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  final bool? status;
  final Data? data;
  final String? message;

  LoginResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  final User? user;
  final String? accessToken;

  Data({
    this.user,
    this.accessToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  final DateTime? emailVerifiedAt;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? aclGroups;
  final List<String>? permissions;
  final List<Address>? addresses;
  final dynamic point;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.aclGroups,
    this.permissions,
    this.addresses,
    this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
    phone: json["phone"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    aclGroups: json["aclGroups"] == null ? [] : List<String>.from(json["aclGroups"]!.map((x) => x)),
    permissions: json["permissions"] == null ? [] : List<String>.from(json["permissions"]!.map((x) => x)),
    addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"]!.map((x) => Address.fromJson(x))),
    point: json["point"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "phone": phone,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "aclGroups": aclGroups == null ? [] : List<dynamic>.from(aclGroups!.map((x) => x)),
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
    "addresses": addresses == null ? [] : List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "point": point,
  };
}

class Address {
  final int? id;
  final int? userId;
  final String? type;
  final String? houseNo;
  final String? streetName;
  final String? city;
  final String? county;
  final String? postcode;
  final String? note;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    this.id,
    this.userId,
    this.type,
    this.houseNo,
    this.streetName,
    this.city,
    this.county,
    this.postcode,
    this.note,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    houseNo: json["house_no"],
    streetName: json["street_name"],
    city: json["city"],
    county: json["county"],
    postcode: json["postcode"],
    note: json["note"],
    isDefault: json["is_default"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "house_no": houseNo,
    "street_name": streetName,
    "city": city,
    "county": county,
    "postcode": postcode,
    "note": note,
    "is_default": isDefault,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
