import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:order_online_app/core/utils/app_navigator_key.dart';
import 'package:order_online_app/src/features/authentication/provider/authentication_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/local_storage_key.dart';
import '../../../core/constants/web_endpoint.dart';
import '../../../core/utils/local_storage.dart';
import '../authentication/model/login_response_model.dart';

class WebViewProvider extends ChangeNotifier {
  bool connected = false;
  LoginResponseModel? loginResponseModel;

  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;
  String url = WebEndpoint.baseUrl;
  double progress = 0;
  String pageTitle = 'Loading...';
  bool reloading = false;

  Future<void> getLocalData() async{
    final loginResponseFromLocal = await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
    }
  }

  void updateUrl(String newUrl) {
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

  void configureWebViewController(String urlPath) {
    url = '${WebEndpoint.baseUrl}$urlPath';

    webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))));
    webViewController?.evaluateJavascript(source: 'localStorage.setItem("accessToken", "${loginResponseModel?.accessToken}");');
  }

  Future<void> configurePullToRefreshController() async{
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
          color: AppColor.secondaryColor, backgroundColor: AppColor.cardColor),
      onRefresh: () async {
        await refresh();
      },
    );
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
