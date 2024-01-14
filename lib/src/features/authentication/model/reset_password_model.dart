import 'dart:convert';

ResetPasswordResponseModel resetPasswordResponseModelFromJson(String str) =>
    ResetPasswordResponseModel.fromJson(json.decode(str));

class ResetPasswordResponseModel {
  final bool? status;
  final dynamic data;
  final String? message;

  ResetPasswordResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponseModel(
        status: json["status"],
        data: json["data"],
        message: json["message"],
      );
}
