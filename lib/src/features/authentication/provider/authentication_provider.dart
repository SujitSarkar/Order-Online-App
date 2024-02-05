import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:order_online_app/core/constants/app_string.dart';
import 'package:order_online_app/src/features/authentication/model/reset_password_model.dart';
import 'package:order_online_app/src/features/home/provider/home_provider.dart';
import 'package:order_online_app/src/features/webview/webview_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/utils/validator.dart';
import '../../../../shared/api/api_service.dart';
import '../model/login_response_model.dart';
import '../repository/auth_repository.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool loading = false;
  bool googleLoading = false;
  bool facebookLoading = false;
  final GlobalKey<FormState> signupFormKey = GlobalKey();
  final GlobalKey<FormState> signInFormKey = GlobalKey();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool rememberMe = true;
  bool privacyPolicyUrl = true;
  late UserCredential? googleUserCredential;
  late UserCredential? facebookUserCredential;

  ///Functions::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void clearAllData() {
    loading = false;
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    phoneController.clear();
  }

  void clearPassword() {
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void rememberMeOnChange(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  void privacyPolicyUrlOnChange(bool value) {
    privacyPolicyUrl = value;
    notifyListeners();
  }

  Future<void> signupButtonOnTap(String fromPage) async {
    debugPrint('Triggered from $fromPage');
    ApiService.instance.clearAccessToken();
    if (!signupFormKey.currentState!.validate()) {
      return;
    }
    if (!validateEmail(emailController.text)) {
      showToast('Invalid email address');
      return;
    }
    if (!validatePassword(passwordController.text)) {
      showToast('Password must be at least 8 characters');
      return;
    }
    if (!validatePassword(confirmPasswordController.text)) {
      showToast('Password must be at least 8 characters');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showToast('Password does\'nt match');
      return;
    }
    loading = true;
    notifyListeners();
    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "password": passwordController.text.trim(),
      "password_confirmation": confirmPasswordController.text.trim(),
      "device_name": "Dev1@CF"
    };
    debugPrint(requestBody.toString());

    await _authRepository
        .signup(requestBody: requestBody)
        .then((response) async {
      loading = false;
      notifyListeners();
      if (response != null) {
        await setData(LocalStorageKey.loginResponseKey, loginResponseModelToJson(response)).then((value) async {
          final BuildContext context = AppNavigatorKey.key.currentState!.context;
          final HomeProvider homeProvider = Provider.of(context,listen: false);
          homeProvider.initialize();
          ApiService.instance.addAccessToken(response.data?.accessToken);
          clearAllData();
          if(fromPage==AppString.fromPageList.last){
            final WebViewProvider webViewProvider = Provider.of(context,listen: false);
            webViewProvider.getLocalData();
            Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.webViewPage);
          }else{
           Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home);
          }
        }, onError: (error) {
          showToast(error.toString());
        });
      }
    });
  }

  Future<void> signInButtonOnTap(String fromPage) async {
    debugPrint('Triggered from $fromPage');
    ApiService.instance.clearAccessToken();
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    if (!validateEmail(emailController.text)) {
      showToast('Invalid email address');
      return;
    }
    loading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "device_name": "Dev1@CF",
      "remember": 'false'
    };

    await _authRepository.signIn(requestBody: requestBody).then(
        (LoginResponseModel? response) async {
      if (response != null) {
        await setData(LocalStorageKey.loginResponseKey,
            loginResponseModelToJson(response)).then((value) async {
          final BuildContext context = AppNavigatorKey.key.currentState!.context;
          ApiService.instance.addAccessToken(response.data?.accessToken);
          final HomeProvider homeProvider = Provider.of(context,listen: false);
          homeProvider.initialize();
          clearAllData();
          if(fromPage==AppString.fromPageList.last){
            final WebViewProvider webViewProvider = Provider.of(context,listen: false);
            webViewProvider.getLocalData();
            Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.webViewPage);
          }else{
            Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home);
          }
        }, onError: (error) {
          showToast(error.toString());
        });
      }
    }, onError: (error) {
      showToast(error.toString());
    });
    loading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle(String fromPage) async {
    debugPrint('Triggered from $fromPage');
    ApiService.instance.clearAccessToken();
    googleLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      googleUserCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (googleUserCredential != null) {
        debugPrint(googleUserCredential!.user!.uid);
        debugPrint(googleUserCredential!.user!.displayName);
        debugPrint(googleUserCredential!.user!.email);

        final Map<String, dynamic> requestBody = {
          'authProvider': 'google',
          'uid': googleUserCredential?.user?.uid,
          'name': googleUserCredential?.user?.displayName,
          'email': googleUserCredential?.user?.email,
          "device_name": "Dev1@CF",
        };

        await _authRepository.socialLogin(requestBody: requestBody).then(
            (LoginResponseModel? response) async {
          if (response != null) {
            await setData(LocalStorageKey.loginResponseKey,
                    loginResponseModelToJson(response)).then((value) async {
              final BuildContext context = AppNavigatorKey.key.currentState!.context;
              ApiService.instance.addAccessToken(response.data?.accessToken);
              final HomeProvider homeProvider = Provider.of(context,listen: false);
              homeProvider.initialize();
              clearAllData();
              if(fromPage==AppString.fromPageList.last){
                final WebViewProvider webViewProvider = Provider.of(context,listen: false);
                webViewProvider.getLocalData();
                Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.webViewPage);
              }else{
                Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home);
              }
            }, onError: (error) {
              showToast(error.toString());
            });
          }
        }, onError: (error) {
          showToast(error.toString());
        });
      } else {
        showToast('User data not found');
      }
    } catch (error) {
      showToast('Google login failed');
      debugPrint('Google Login Error: ${error.toString()}');
    }
    googleLoading = false;
    notifyListeners();
  }

  Future<void> signInWithFacebook(String fromPage) async {
    debugPrint('Triggered from $fromPage');
    /// SHA1 after remove special char = 2B7EACA3F0F2838DD982AEE53CDBC6B743A4DE19

    /// Bundle ID = com.digitafact.orderOnlineApp
    /// Package Name = com.digitafact.order_online_app
    /// Default Activity Class Name = com.digitafact.order_online_app.MainActivity
    /// Key Hashes = K36so/Dyg43Zgq7lPNvGt0Ok3hk=

    ApiService.instance.clearAccessToken();
    facebookLoading = true;
    notifyListeners();

    try{
      final LoginResult result = await FacebookAuth.instance.login();
        if(result.status == LoginStatus.success){
          final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
          facebookUserCredential = await FirebaseAuth.instance.signInWithCredential(credential);

          debugPrint(facebookUserCredential!.user!.uid);
          debugPrint(facebookUserCredential!.user!.displayName);
          debugPrint(facebookUserCredential!.user!.email);

          final Map<String, dynamic> requestBody = {
            'authProvider': 'facebook',
            'uid': facebookUserCredential?.user?.uid,
            'name': facebookUserCredential?.user?.displayName,
            'email': facebookUserCredential?.user?.email,
            "device_name": "Dev1@CF",
          };

          await _authRepository.socialLogin(requestBody: requestBody).then(
                  (LoginResponseModel? response) async {
                if (response != null) {
                  await setData(LocalStorageKey.loginResponseKey,
                      loginResponseModelToJson(response)).then((value) async {
                    final BuildContext context = AppNavigatorKey.key.currentState!.context;
                    ApiService.instance.addAccessToken(response.data?.accessToken);
                    final HomeProvider homeProvider = Provider.of(context,listen: false);
                    homeProvider.initialize();
                    clearAllData();
                    if(fromPage==AppString.fromPageList.last){
                      final WebViewProvider webViewProvider = Provider.of(context,listen: false);
                      webViewProvider.getLocalData();
                      Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.webViewPage);
                    }else{
                      Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.home);
                    }
                  }, onError: (error) {
                    showToast(error.toString());
                  });
                }
              }, onError: (error) {
            showToast(error.toString());
          });
        }else if(result.status == LoginStatus.cancelled){
          showToast('Facebook login canceled');
        }else if(result.status == LoginStatus.failed){
          showToast('Facebook login failed');
        }else{
          showToast('Facebook Login Status: ${result.status.toString()}');
        }
    }catch(error) {
      showToast('Facebook Login Error: ${error.toString()}');
      debugPrint('Facebook Login Error: ${error.toString()}');
    }
    facebookLoading = false;
    notifyListeners();
  }

  Future<void> resetPasswordButtonOnTap() async {
    ApiService.instance.clearAccessToken();
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }
    if (!validateEmail(emailController.text)) {
      showToast('Invalid email address');
      return;
    }
    loading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {"email": emailController.text.trim()};

    await _authRepository.resetPassword(requestBody: requestBody).then(
        (ResetPasswordResponseModel? response) async {
      if (response != null && response.status == true) {
        showToast(response.message ?? '');
        Navigator.pop(AppNavigatorKey.key.currentState!.context);
      }
    }, onError: (error) {
      showToast(error.toString());
    });
    loading = false;
    notifyListeners();
  }
}
