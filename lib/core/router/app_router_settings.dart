import 'package:flutter/material.dart';
import '../../src/features/authentication/view/forgot_password_screen.dart';
import '../../src/features/authentication/view/signup_screen.dart';
import '../../src/features/authentication/view/signin_screen.dart';
import '../../src/features/home/screen/home_screen.dart';
import '../../src/features/privacy/privacy_and_terms_screen.dart';
import '../../src/features/splash/splash_screen.dart';
import '../../src/features/webview/webview_screen.dart';
import '../widgets/no_internet_screen.dart';
import 'app_router.dart';

class GeneratedRoute {
  static PageRouteBuilder onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouter.initializer:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const SplashScreen());

      case AppRouter.signIn:
        final String arguments = settings.arguments as String;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                SignInScreen(fromPage: arguments));

      case AppRouter.signup:
        final String arguments = settings.arguments as String;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            SignupScreen(fromPage: arguments));

      case AppRouter.forgotPassword:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            const ForgotPasswordScreen());

      case AppRouter.privacyTerms:
        final String url = settings.arguments as String;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            PrivacyAndTermsScreen(url: url));

      case AppRouter.home:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const HomeScreen());

      case AppRouter.noInternet:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            const NoInternetScreen());

      case AppRouter.webViewPage:
        final String urlPath = settings.arguments as String;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: slideTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
            WebViewScreen(urlPath: urlPath));

      default:
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: fadeTransition,
            pageBuilder: (_, animation, secondaryAnimation) =>
                const SplashScreen());
    }
  }

  static Widget fadeTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget slideTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const begin = Offset(1, 0);
    const end = Offset.zero;
    const curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
