import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:order_online_app/src/features/authentication/model/reset_password_model.dart';
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
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool rememberMe = true;
  bool privacyPolicyUrl = true;
  late UserCredential? userCredential;

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

  Future<void> signupButtonOnTap() async {
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

    await _authRepository.signup(requestBody: requestBody).then((response) async{
      loading = false;
      notifyListeners();
      if (response != null) {
        await setData(LocalStorageKey.loginResponseKey,
            loginResponseModelToJson(response)).then((value) async {
          final BuildContext context = AppNavigatorKey.key.currentState!.context;
          ApiService.instance.addAccessToken(response.data?.accessToken);
          clearAllData();
          final WebViewProvider webViewProvider = Provider.of(context,listen: false);
          // await webViewProvider.refresh();
          await webViewProvider.getLocalData();
          await webViewProvider.setLocalStorage();
          await webViewProvider.refresh().then((value){
            Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.webViewPage);
          });
        }, onError: (error) {
          showToast(error.toString());
        });
      }
    });
  }

  Future<void> signInButtonOnTap() async {
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
          clearAllData();
          final WebViewProvider webViewProvider = Provider.of(context,listen: false);
          // await webViewProvider.refresh();
          await webViewProvider.getLocalData();
          await webViewProvider.setLocalStorage();
          await webViewProvider.refresh().then((value){
            Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.webViewPage);
          });
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

  Future<void> signInWithGoogle() async {
    ApiService.instance.clearAccessToken();
    googleLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential != null) {
        debugPrint(userCredential!.user!.uid);
        debugPrint(userCredential!.user!.displayName);
        debugPrint(userCredential!.user!.email);

        final Map<String, dynamic> requestBody = {
          'authProvider': 'google',
          'uid': userCredential?.user?.uid,
          'name': userCredential?.user?.displayName,
          'email': userCredential?.user?.email,
          "device_name": "Dev1@CF",
        };

        await _authRepository.socialLogin(requestBody: requestBody).then(
            (LoginResponseModel? response) async {
          if (response != null) {
            await setData(LocalStorageKey.loginResponseKey,
                    loginResponseModelToJson(response)).then((value) async {
              final BuildContext context = AppNavigatorKey.key.currentState!.context;
              ApiService.instance.addAccessToken(response.data?.accessToken);
              clearAllData();
              final WebViewProvider webViewProvider = Provider.of(context,listen: false);
              // await webViewProvider.refresh();
              await webViewProvider.getLocalData();
              await webViewProvider.setLocalStorage();
              await webViewProvider.refresh().then((value){
                Navigator.of(context).popUntil((route) => route.settings.name == AppRouter.webViewPage);
              });
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
          if (response != null && response.status==true) {
            showToast(response.message??'');
            Navigator.pop(AppNavigatorKey.key.currentState!.context);
          }
        }, onError: (error) {
      showToast(error.toString());
    });
    loading = false;
    notifyListeners();
  }
}
