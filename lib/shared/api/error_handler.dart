import '../../core/utils/app_toast.dart';
import '../../src/features/authentication/repository/auth_repository.dart';
import 'api_service.dart';
import 'app_exceptions.dart';

class ErrorHandler {
  static void handleError(exception) async {
    if (exception is DataParsingException) {
      showToast(exception.message!);
    } else if (exception is ApiNotRespondingException) {
      showToast(exception.message!);
    } else if (exception is UnauthorizedException) {
      //If access token has un authorised then logout

      if (ApiService.instance.headers['Authorization'] != null &&
          ApiService.instance.headers['Authorization']!.isNotEmpty) {
        await AuthRepository().logout();
        showToast(exception.message!);
      }
      showToast(exception.message!);
    } else if (exception is InvalidCredentialsException) {
      showToast(exception.message!);
    } else if (exception is BadRequestException) {
      showToast(exception.message!);
    } else if (exception is ExpectationException) {
      showToast(exception.message!);
    } else if (exception is SocketException) {
      showToast(exception.message!);
    }
  }
}
