import 'package:url_launcher/url_launcher.dart';
import 'app_toast.dart';

Future<void> launchInWebView(String url) async {
  try {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
      showToast('Could not launch $url');
    }
  } catch (error) {
    showToast(error.toString());
  }
}