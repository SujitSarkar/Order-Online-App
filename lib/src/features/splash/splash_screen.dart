import 'dart:async';
import 'package:flutter/material.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/router/app_router.dart';

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
    final HomeProvider homeProvider = Provider.of(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await homeProvider.initialize().then((value) => Navigator.pushNamedAndRemoveUntil(
          context, AppRouter.home, (route) => false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Center(
            child: Text(AppString.appName,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold))));
  }
}
