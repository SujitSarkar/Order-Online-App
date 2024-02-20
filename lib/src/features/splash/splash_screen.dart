import 'dart:async';
import 'package:flutter/material.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Image.asset('assets/images/logo512.png',height:180,width:180)),
            // child: Text(AppString.appName,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold))),
    );
  }
}
