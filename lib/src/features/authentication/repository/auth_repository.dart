import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../model/logout_response_model.dart';

class AuthRepository {
  Future<void> logout() async {
    await clearLocalData();
    ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.logout}',
          fromJson: LogoutResponseModel.fromJson);
    }, onSuccess: (result) async {
      final LogoutResponseModel response = result as LogoutResponseModel;
      showToast('${response.message}');
    }, onError: (error) {
      // ApiException apiException = error as ApiException;
      // debugPrint(apiException.message);
      // showToast(error.message);
    });
    FirebaseAuth.instance.signOut();
    ApiService.instance.clearAccessToken();
  }
}
