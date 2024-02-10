import 'dart:convert';

LogoutResponseModel logoutResponseModelFromJson(String str) => LogoutResponseModel.fromJson(json.decode(str));

class LogoutResponseModel {
  final bool? status;
  final Data? data;
  final String? message;

  LogoutResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) => LogoutResponseModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );
}

class Data {
  final String? name;
  final String? email;

  Data({
    this.name,
    this.email,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    email: json["email"],
  );
}
