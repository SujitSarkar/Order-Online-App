import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/loading_widget.dart';

class PrivacyAndTermsScreen extends StatefulWidget {
  const PrivacyAndTermsScreen({super.key, required this.url});
  final String url;

  @override
  State<PrivacyAndTermsScreen> createState() => _PrivacyAndTermsScreenState();
}

class _PrivacyAndTermsScreenState extends State<PrivacyAndTermsScreen> {
  late String webUrl;
  InAppWebViewController? webViewController;

  late PullToRefreshController pullToRefreshController = PullToRefreshController(
    settings: PullToRefreshSettings(
        color: AppColor.secondaryColor, backgroundColor: AppColor.cardColor),
    onRefresh: () async {
      await refresh();
    },
  );

  double progress = 0;
  bool reloading = false;

  @override
  void initState() {
    onInit();
    super.initState();
  }

  Future<void> onInit()async{
    webUrl = widget.url;
    await webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(webUrl))));
    hideBottomNavBar();
  }

  void hideBottomNavBar(){
    webViewController?.evaluateJavascript(source: "document.querySelector('nav').style.display = 'none'");
    webViewController?.evaluateJavascript(source: "document.querySelector('footer').style.display = 'none'");
  }

  Future<void> refresh() async {
    if (Platform.isAndroid) {
      webViewController?.reload();
    } else if (Platform.isIOS) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(url: await webViewController?.getUrl()));
    }
    hideBottomNavBar();
  }

  void updateUrl(String newUrl) async{
    webUrl = newUrl;
    debugPrint('\n\n Updated URL:::::::::::::::::::::::::::::: $newUrl \n\n');
    hideBottomNavBar();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
              children: <Widget>[
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.parse(webUrl))),
                    pullToRefreshController:
                    pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onProgressChanged:
                        (InAppWebViewController? controller, int? progress) {
                     updateProgress(controller, progress);
                    },
                    onLoadStart: (controller, url) {
                      updateUrl(url.toString());
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      updateUrl(url.toString());
                    },
                    onReceivedError: (controller, url, error) {
                      pullToRefreshController.endRefreshing();
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      updateUrl(url.toString());
                    },
                  ),
                )
                // ignore: unnecessary_null_comparison
              ].where((Object o) => o != null).toList()),
          if (progress != 1.0 && reloading == false)
            Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppColor.cardColor,
                alignment: Alignment.center,
                child: const LoadingWidget()),
        ],
      ),
    );
  }
}
