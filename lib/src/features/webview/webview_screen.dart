import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final WebViewProvider webViewProvider = Provider.of(context, listen: false);

    webViewProvider.configureWebViewController(widget.urlPath);
    webViewProvider.configurePullToRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    final WebViewProvider webViewProvider = Provider.of(context);
    return PopScope(
      canPop: false, // Allow popping by default
      onPopInvoked: (value) async {
        bool canBack = await webViewProvider.webViewController!.canGoBack();
        if (canBack) {
          webViewProvider.webViewController!.goBack();
        } else {
          // ignore: use_build_context_synchronously
          final shouldExit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Do you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:
                      const Text('No', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
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
            Column(
                children: <Widget>[
              Expanded(
                child: InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(
                      url: WebUri.uri(Uri.parse(webViewProvider.url))),
                  pullToRefreshController:
                      webViewProvider.pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewProvider.webViewController = controller;
                  },
                  onProgressChanged:
                      (InAppWebViewController? controller, int? progress) {
                    webViewProvider.updateProgress(controller, progress);
                  },
                  onTitleChanged:
                      (InAppWebViewController? controller, String? title) {
                    setState(() => webViewProvider.pageTitle = title!);
                  },
                  onLoadStart: (controller, url) {
                    webViewProvider.updateUrl(url.toString());
                  },
                  onLoadStop: (controller, url) async {
                    webViewProvider.pullToRefreshController.endRefreshing();
                    webViewProvider.updateUrl(url.toString());
                  },
                  onReceivedError: (controller, url, error) {
                    webViewProvider.pullToRefreshController.endRefreshing();
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    webViewProvider.updateUrl(url.toString());
                  },
                ),
              )
              // ignore: unnecessary_null_comparison
            ].where((Object o) => o != null).toList()),
            if (webViewProvider.progress != 1.0 &&
                webViewProvider.reloading == false)
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: AppColor.cardColor,
                  alignment: Alignment.center,
                  child: const LoadingWidget()),
            if (!webViewProvider.connected) const NoInternetScreen()
          ],
        ),
      );
}
