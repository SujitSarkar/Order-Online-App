import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:order_online_app/src/features/webview/webview_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/local_storage.dart';
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
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<LoginResponseModel?> signup({required Map<String, dynamic> requestBody}) async {
    LoginResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signup}',
          body: requestBody);
    }, onSuccess: (response) async {
      debugPrint(response.body);
      result = loginResponseModelFromJson(response.body);
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<LoginResponseModel?> socialLogin({required Map<String, dynamic> requestBody}) async {
    LoginResponseModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.socialLogin}',
          body: requestBody);
    }, onSuccess: (response) async {
      result = loginResponseModelFromJson(response.body);
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
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
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
    });
    return result;
  }

  Future<void> logout()async{
    final WebViewProvider webViewProvider = Provider.of(AppNavigatorKey.key.currentState!.context);
    ApiService.instance.clearAccessToken();
    await clearLocalData();
    await FirebaseAuth.instance.signOut();
    await webViewProvider.clearLocalStorage();
    // await ApiService.instance.apiCall(execute: () async {
    //   return await ApiService.instance.post(
    //       '${ApiEndpoint.baseUrl}${ApiEndpoint.logout}');
    // }, onSuccess: (response) async {
    //   ApiService.instance.clearAccessToken();
    //   await clearLocalData();
    //   await FirebaseAuth.instance.signOut().then((value) => Navigator.pushNamedAndRemoveUntil(
    //       AppNavigatorKey.key.currentState!.context, AppRouter.signIn, (route) => false));
    // }, onError: (error) {
    //   debugPrint(error.message ?? 'Something went wrong');
    // });
  }
}
