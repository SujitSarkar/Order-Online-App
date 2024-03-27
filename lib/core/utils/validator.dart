import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

bool validateEmail(String emailAddress) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(emailAddress);

bool validatePassword(String password) => password.length >= 8;

bool isVideoUrl(String url) {
  final RegExp videoExtensions = RegExp(r'\.(mp4|avi|mov|wmv)$', caseSensitive: false);
  return videoExtensions.hasMatch(url);
}

Future<void> openUrlOnExternal(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (error) {
    debugPrint('Error launching url: $error');
  }
}
