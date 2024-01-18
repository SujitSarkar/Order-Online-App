import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import 'package:order_online_app/src/features/authentication/model/login_response_model.dart';
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
  final StreamController<int> _controller = StreamController<int>();

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> onInit() async {
    LoginResponseModel? loginResponseModel;
    final loginResponseFromLocal =
        await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
    }

    await Future.delayed(const Duration(milliseconds: 1200)).then((value) {
      if (loginResponseModel != null &&
          loginResponseModel.data?.accessToken != null) {
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
    return const Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Center(
            child: Hero(
          tag: 'splashToSignIn',
          child: Text(AppString.appName,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold)),
        )));
  }
}
