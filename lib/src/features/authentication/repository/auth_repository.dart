import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:order_online_app/core/utils/app_toast.dart';
import 'package:order_online_app/core/utils/local_storage.dart';
import 'package:order_online_app/src/features/authentication/model/logout_response_model.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';

class AuthRepository {
  Future<void> logout() async {
    await clearLocalData();
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.logout}',
          fromJson: LogoutResponseModel.fromJson);
    }, onSuccess: (result) async {
      final LogoutResponseModel response = result as LogoutResponseModel;
      showToast('${response.message}');
    }, onError: (error) {
      debugPrint(error.errors ?? 'Error Logout');
      showToast(error.errors ?? 'Error Logout');
    });
    FirebaseAuth.instance.signOut();
    ApiService.instance.clearAccessToken();
  }
}
