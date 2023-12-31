import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:order_online_app/src/features/authentication/provider/authentication_provider.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:order_online_app/src/features/tab_bar/provider/tab_bar_provider.dart';
import 'package:order_online_app/src/features/webview/webview_provider.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_string.dart';
import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/router/app_router_settings.dart';
import 'core/utils/app_navigator_key.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>(
              create: (_) => AuthenticationProvider()),
          ChangeNotifierProvider<TabBarProvider>(
              create: (_) => TabBarProvider()),
          ChangeNotifierProvider<HomeProvider>(create: (_) {
            final HomeProvider homeProvider = HomeProvider();
            homeProvider.initialize();
            return homeProvider;
          }),
          ChangeNotifierProvider<WebViewProvider>(create: (_) {
            final WebViewProvider webViewProvider = WebViewProvider();
            webViewProvider.checkConnectivity();
            return webViewProvider;
          }),
        ],
        child: MaterialApp(
          navigatorKey: AppNavigatorKey.key,
          title: AppString.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          initialRoute: AppRouter.initializer,
          onGenerateRoute: (RouteSettings settings) =>
              GeneratedRoute.onGenerateRoute(settings),
        ));
  }
}
