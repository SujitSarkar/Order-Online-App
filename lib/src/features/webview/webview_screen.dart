import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:order_online_app/core/router/app_router.dart';
import 'package:order_online_app/core/utils/local_storage.dart';
import 'package:order_online_app/src/features/webview/webview_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/no_internet_screen.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.urlPath});
  final String urlPath;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final WebViewProvider webViewProvider = Provider.of(context, listen: false);
    webViewProvider.configureWebViewController(widget.urlPath);
    await webViewProvider.getLocalData();
    await webViewProvider.setLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    final WebViewProvider webViewProvider = Provider.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        bool canBack = await webViewProvider.webViewController!.canGoBack();
        if (canBack) {
          webViewProvider.webViewController!.goBack();
        } else {
          //ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false);
        }
      },
      child: Scaffold(
          backgroundColor: AppColor.cardColor, body: _bodyUI(webViewProvider)),
    );
  }

  SafeArea _bodyUI(WebViewProvider webViewProvider) => SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: WebUri.uri(Uri.parse(webViewProvider.url))),
                  pullToRefreshController: webViewProvider.pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewProvider.webViewController = controller;
                    webViewProvider.webViewController?.addJavaScriptHandler(
                      handlerName: 'callNativeLogin',
                      callback: (args) {
                        callNativeLogin();
                      },
                    );
                    webViewProvider.webViewController?.addJavaScriptHandler(
                      handlerName: 'callNativeLogout',
                      callback: (args) {
                        callNativeLogout();
                      },
                    );
                  },
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    allowsInlineMediaPlayback: true,
                    preferredContentMode: UserPreferredContentMode.MOBILE,
                  ),
                  onProgressChanged:
                      (InAppWebViewController? controller, int? progress) {
                    debugPrint(
                        '::::::::::::::onProgressChanged:::::::::::::::::');
                    webViewProvider.updateProgress(controller, progress);
                  },
                  onLoadStop: (controller, url) async {
                    debugPrint('::::::::::::::onLoadStop:::::::::::::::::');
                    webViewProvider.pullToRefreshController.endRefreshing();
                  },
                  onReceivedError: (controller, url, error) {
                    webViewProvider.pullToRefreshController.endRefreshing();
                  },
                  onUpdateVisitedHistory:
                      (controller, url, androidIsReload) async {
                    debugPrint(
                        '::::::::::::::onUpdateVisitedHistory:::::::::::::::::${url.toString()}');
                    webViewProvider.updateUrl(url.toString());
                    await webViewProvider.setLocalStorage();
                  },
                  onLoadResource: (controller, resource) {
                    debugPrint('::::::::::::::onLoadResource:::::::::::::::::');
                    debugPrint(
                        '::::::::::::::${resource.url}:::::::::::::::::');
                  },
                ),
              )
              // ignore: unnecessary_null_comparison
            ].where((Object o) => o != null).toList()),
            if (webViewProvider.progress != 1.0 && webViewProvider.reloading == false)
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: AppColor.cardColor,
                  alignment: Alignment.center,
                  child: const LoadingWidget()),

            ///No Internet Widget
            if (!webViewProvider.connected) const NoInternetScreen(),

            ///Back Button
            if(webViewProvider.connected)
              Positioned(
                top: 65,
                left: 10,
                child: InkWell(
                  onTap: (){
                    Navigator.popUntil(context, (route) => route.settings.name==AppRouter.home);
                  },
                  child: const CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    child: Icon(Icons.arrow_back_ios_new,color: Colors.white),
                  ),
              ))
          ],
        ),
      );

  void callNativeLogin()=> Navigator.pushNamed(context, AppRouter.signIn);

  void callNativeLogout() async {
    WebViewProvider webViewProvider = Provider.of(context, listen: false);
    await clearLocalData();
    await webViewProvider.clearLocalStorage();
    await webViewProvider.refresh();
    await FirebaseAuth.instance.signOut();
  }
}
