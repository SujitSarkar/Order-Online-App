import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/local_storage_key.dart';
import '../../../core/constants/web_endpoint.dart';
import '../../../core/utils/local_storage.dart';
import '../authentication/model/login_response_model.dart';

class WebViewProvider extends ChangeNotifier {
  bool connected = false;
  LoginResponseModel? loginResponseModel;

  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController = PullToRefreshController(
    settings: PullToRefreshSettings(
        color: AppColor.secondaryColor, backgroundColor: AppColor.cardColor),
    onRefresh: () async {
      await refresh();
    },
  );
  String url = WebEndpoint.baseUrl;
  double progress = 0;
  String pageTitle = 'Loading...';
  bool reloading = false;

  Future<void> getLocalData() async {
    final loginResponseFromLocal =
        await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
    }
  }

  void updateUrl(String newUrl) async{
    url = newUrl;
    notifyListeners();
    debugPrint('\n\n Updated URL:::::::::::::::::::::::::::::: $newUrl \n\n');
    await setLocalStorage();
  }

  Future<void> refresh() async {
    if (Platform.isAndroid) {
      webViewController?.reload();
    } else if (Platform.isIOS) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(url: await webViewController?.getUrl()));
    }
    await setLocalStorage();
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

  void configureWebViewController(String urlPath) async{
    url = '${WebEndpoint.baseUrl}$urlPath';

    webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))));
  }

  Future<void> setLocalStorage()async{
    try {
      await webViewController?.evaluateJavascript(
          source: "localStorage.setItem('accessToken', '${loginResponseModel?.data?.accessToken}');");
    } catch (e) {
      debugPrint('\n\nError save local storage $e\n\n');
    }

    String? value = await webViewController?.evaluateJavascript(
        source: "localStorage.getItem('accessToken');"
    );
    debugPrint("\n\n\nRetrieved value: $value\n\n\n");
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
