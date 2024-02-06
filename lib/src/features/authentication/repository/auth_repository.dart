import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:order_online_app/core/utils/app_toast.dart';
import 'package:order_online_app/core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../model/login_response_model.dart';
import '../model/reset_password_model.dart';

class AuthRepository {
  Future<LoginResponseModel?> signIn(
      {required Map<String, dynamic> requestBody}) async {
    LoginResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signIn}',
          body: requestBody);
    }, onSuccess: (response) async {
      debugPrint(response.body);
      result = loginResponseModelFromJson(response.body);
      showToast(result!.message ?? '');
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
      showToast(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<LoginResponseModel?> signup(
      {required Map<String, dynamic> requestBody}) async {
    LoginResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signup}',
          body: requestBody);
    }, onSuccess: (response) async {
      debugPrint(response.body);
      result = loginResponseModelFromJson(response.body);
      showToast(result!.message ?? '');
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
      showToast(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<LoginResponseModel?> socialLogin(
      {required Map<String, dynamic> requestBody}) async {
    LoginResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.socialLogin}',
          body: requestBody);
    }, onSuccess: (response) async {
      result = loginResponseModelFromJson(response.body);
      showToast(result!.message ?? '');
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
      showToast(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<ResetPasswordResponseModel?> resetPassword(
      {required Map<String, dynamic> requestBody}) async {
    ResetPasswordResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.forgetPassword}',
          body: requestBody);
    }, onSuccess: (response) async {
      debugPrint(response.body);
      result = resetPasswordResponseModelFromJson(response.body);
      showToast(result!.message ?? '');
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
      showToast(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<void> logout() async {
    await clearLocalData();
    ApiService.instance.apiCall(
        execute: () async {
          return await ApiService.instance
              .post('${ApiEndpoint.baseUrl}${ApiEndpoint.logout}');
        },
        onSuccess: (response) async {
          final jsonData = jsonDecode(response.body);
          showToast(jsonData['message']);
        },
        onError: (error) {
          debugPrint(error.message ?? 'Error Logout');
          showToast(error.message ?? 'Error Logout');
        });
    FirebaseAuth.instance.signOut();
    ApiService.instance.clearAccessToken();
  }
}
