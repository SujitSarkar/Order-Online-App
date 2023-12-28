import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/app_string.dart';
import '../constants/text_size.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          color: AppColor.appBodyBg,
          height: double.infinity,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                      const Icon(Icons.wifi_off, color: AppColor.warningColor, size: 100),
                      const Text(AppString.noInternetConnection),
                      const SizedBox(height: 10),
                      TextButton(
            onPressed: () async {},
            child: const Text(
              'Refresh',
              style: TextStyle(
                  color: AppColor.secondaryColor,
                  fontSize: TextSize.buttonText),
            ))
                    ]),
        ));
  }
}
