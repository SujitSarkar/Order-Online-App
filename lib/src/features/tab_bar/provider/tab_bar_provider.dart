import 'package:flutter/Material.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/constants/web_endpoint.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_service.dart';
import '../../authentication/model/login_response_model.dart';
import '../../home/screen/home_screen.dart';
import '../screen/order_screen.dart';
import '../screen/profile_screen.dart';

class TabBarProvider extends ChangeNotifier {
  int tabIndex = 0;

  ///User Data
  LoginResponseModel? loginResponseModel;

  List<Widget> get getTabBarChild =>
      [const HomeScreen(), const OrderScreen(), const ProfileScreen()];

  void initialize() async {
    await getLocalData();
    navigateToWebPage();
  }

  /// UI INTERACTION STATEMENT
  void changeTabIndex(int index) {
    if (index != tabIndex) {
      tabIndex = index;
      notifyListeners();
    }
    navigateToWebPage();
  }

  Future<void> navigateToWebPage() async {
    final BuildContext context = AppNavigatorKey.key.currentState!.context;
    if (tabIndex == 0) {
      // await AuthRepository().logout();
      // await Future.delayed(const Duration(milliseconds: 500)).then((value) =>
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, AppRouter.webViewPage, arguments: '', (route) => false));
    } else if (tabIndex == 1) {
      Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.webViewPage,
          arguments: WebEndpoint.orderUrl,
          (route) => false);
    } else if (tabIndex == 2) {
      Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.webViewPage,
          arguments: WebEndpoint.profileUrl,
          (route) => false);
    }
  }

  bool canPop() => AppNavigatorKey.key.currentState!.canPop();

  ///Functions:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> getLocalData() async {
    final loginResponseFromLocal = await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
      ApiService.instance.addAccessToken(loginResponseModel?.data?.accessToken);
    }
  }
}
