import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/local_storage_key.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  Future<void> onInit() async {
    final loginResponseFromLocal = getData(LocalStorageKey.loginResponseKey);

    await Future.delayed(const Duration(seconds: 2)).then((value) {
      // Navigator.pushNamedAndRemoveUntil(
      //     context, AppRouter.tabBar, (route) => false);

      if (loginResponseFromLocal != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRouter.tabBar, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRouter.signIn, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cardColor,
        body: Center(
            child: Hero(
      tag: 'splashToSignIn',
      child: Image.asset('assets/images/splash_logo.png'),
    )));
  }
}
