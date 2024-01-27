import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/local_storage_key.dart';
import '../../../core/constants/web_endpoint.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/local_storage.dart';
import '../authentication/model/login_response_model.dart';

class WebViewProvider extends ChangeNotifier {
  bool connected = true;
  LoginResponseModel? loginResponseModel;

  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController =
      PullToRefreshController(
    settings: PullToRefreshSettings(
        color: AppColor.secondaryColor, backgroundColor: AppColor.cardColor),
    onRefresh: () async => await refresh(),
  );
  String url = WebEndpoint.baseUrl;
  double progress = 0;
  bool reloading = false;

  Future<void> goBack(BuildContext context) async {
    bool canBack = await webViewController!.canGoBack();
    if (canBack) {
      webViewController!.goBack();
    } else {
      //ignore: use_build_context_synchronously
      Navigator.popUntil(context, (route) => route.settings.name == AppRouter.home);
    }
  }

  Future<void> checkConnectivity() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        connected = true;
      } else if (result == ConnectivityResult.wifi) {
        connected = true;
      } else if (result == ConnectivityResult.ethernet) {
        connected = true;
      } else {
        connected = false;
      }
      notifyListeners();
      refresh();
      debugPrint('Internet connected: $connected');
    });
  }

  Future<void> getLocalData() async {
    final loginResponseFromLocal =
        await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
    }
  }

  void updateUrl(String newUrl) async {
    url = newUrl;
    notifyListeners();
    debugPrint('\n\n Updated URL:::::::::::::::::::::::::::::: $newUrl \n\n');
  }

  Future<void> refresh() async {
    if (Platform.isAndroid) {
      webViewController?.reload();
    } else if (Platform.isIOS) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(url: await webViewController?.getUrl()));
    }
    notifyListeners();
  }

  void configureWebViewController(String urlPath) async {
    url = '${WebEndpoint.baseUrl}$urlPath';
    webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))));
  }

  Future<void> setLocalStorage() async {
    if(loginResponseModel?.data?.accessToken!=null){
      await webViewController?.evaluateJavascript(
          source: "localStorage.setItem('accessToken', '${loginResponseModel?.data?.accessToken}');");
    }

    String? value = await webViewController?.evaluateJavascript(
        source: "localStorage.getItem('accessToken');");
    debugPrint("\n\n\nRetrieved localStorage::::::::::::::::::: $value\n\n\n");
  }

  Future<void> clearLocalStorage() async {
    await webViewController?.evaluateJavascript(
        source: "localStorage.setItem('accessToken', '');");
  }

  void updateProgress(InAppWebViewController? controller, int? newProgress) {
    if (progress == 100) {
      pullToRefreshController.endRefreshing();
    }
    pullToRefreshController.isRefreshing().then((value) {
      if (value) {
        reloading = true;
      } else {
        reloading = false;
      }
    });
    progress = (newProgress! / double.parse('100'));
    notifyListeners();
  }
}
