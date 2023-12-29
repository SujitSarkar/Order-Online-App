import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../model/login_response_model.dart';

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

  Future<String?> signup({required Map<String, dynamic> requestBody}) async {
    String? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signup}',
          body: requestBody);
    }, onSuccess: (response) async {
      result = response.body;
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
    });
    return result;
  }

  // Future<void> logout() async {
  //   final AllNewsProvider allNewsProvider =
  //       Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);
  //   final SavedNewsProvider savedNewsProvider =
  //       Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);
  //   final WatchListProvider watchListProvider =
  //       Provider.of(AppNavigatorKey.key.currentState!.context, listen: false);
  //   await clearLocalData().then((value) {
  //     ApiService().headers.remove('Authorization');
  //     allNewsProvider.clearAll();
  //     savedNewsProvider.clearAll();
  //     watchListProvider.clearAll();
  //     Navigator.pushNamedAndRemoveUntil(
  //         AppNavigatorKey.key.currentState!.context,
  //         AppRouter.signIn,
  //         (route) => false);
  //   }, onError: (error) {
  //     showToast(error.toString());
  //   });
  // }

  Future<void> logout()async{
    await clearLocalData();
    await FirebaseAuth.instance.signOut();
  }
}
