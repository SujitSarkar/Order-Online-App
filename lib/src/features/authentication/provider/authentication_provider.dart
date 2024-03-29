import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../core/utils/validator.dart';
import '../../../../shared/api/api_endpoint.dart';
import '../../../../shared/api/api_service.dart';
import '../../home/provider/home_provider.dart';
import '../../webview/webview_provider.dart';
import '../model/login_response_model.dart';
import '../model/reset_password_model.dart';

class AuthenticationProvider extends ChangeNotifier {
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

  ///Errors
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? phoneError;

  ///Functions::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  void clearAllData() {
    loading = false;
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    phoneController.clear();
  }

  void setSignupErrorMessage(Map<String, dynamic> errorMap){
    if(errorMap['email']!=null){
      emailError = errorMap['email'].first;
    }if(errorMap['phone']!=null){
    phoneError = errorMap['phone'].first;
    }if(errorMap['password']!=null){
    passwordError = errorMap['password'].first;
    }if(errorMap['password_confirmation']!=null){
    confirmPasswordError = errorMap['password_confirmation'].first;
    }
  }
  void setSignInErrorMessage(Map<String, dynamic> errorMap){
    if(errorMap['email']!=null){
      emailError = errorMap['email'].first;
    }if(errorMap['password']!=null){
    passwordError = errorMap['password'].first;
    }
  }
  void setResetPasswordErrorMsg(Map<String, dynamic> errorMap){
    if(errorMap['email']!=null){
      emailError = errorMap['email'].first;
    }
  }

  void clearErrorMessage(){
    emailError = null;
    phoneError = null;
    passwordError = null;
    confirmPasswordError = null;
    notifyListeners();
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
    clearErrorMessage();
    debugPrint('Triggered from $fromPage');
    ApiService.instance.clearAccessToken();
    if (!signupFormKey.currentState!.validate()) {
      return;
    }
    if (!validateEmail(emailController.text)) {
      emailError = 'Invalid email address';
      return;
    }
    if (!validatePassword(passwordController.text)) {
      passwordError = 'Password must be at least 8 characters';
      return;
    }
    if (!validatePassword(confirmPasswordController.text)) {
      confirmPasswordError = 'Password must be at least 8 characters';
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      passwordError = 'Password does\'nt match';
      confirmPasswordError = 'Password does\'nt match';
      return;
    }
    loading = true;
    notifyListeners();
    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
      "device_name": "Dev1@CF"
    };
    debugPrint(requestBody.toString());

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signup}',
          body: requestBody,fromJson: LoginResponseModel.fromJson);
    }, onSuccess: (result) async {
      final LoginResponseModel response = result as LoginResponseModel;
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
    }, onError: (error) {
      ApiException apiException = error as ApiException;
      debugPrint('Message: ${apiException.message}');
      debugPrint('Errors: ${apiException.errors}');
      showToast(apiException.message);
      setSignupErrorMessage(apiException.errors??{});
    });
    loading = false;
    notifyListeners();
  }

  Future<void> signInButtonOnTap(String fromPage) async {
    clearErrorMessage();
    debugPrint('Triggered from $fromPage');
    ApiService.instance.clearAccessToken();
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    if (!validateEmail(emailController.text)) {
      emailError = 'Invalid email address';
      return;
    }

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
      "device_name": "Dev1@CF",
      "remember": 'false'
    };
    loading = true;
    notifyListeners();

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.signIn}',
          body: requestBody,fromJson: LoginResponseModel.fromJson);
    }, onSuccess: (result) async {
      final LoginResponseModel response = result as LoginResponseModel;
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
    }, onError: (error) {
      ApiException apiException = error as ApiException;
      debugPrint('Message: ${apiException.message}');
      debugPrint('Errors: ${apiException.errors}');
      showToast(apiException.message);
      setSignInErrorMessage(apiException.errors??{});
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

        await ApiService.instance.apiCall(execute: () async {
          return await ApiService.instance.post(
              '${ApiEndpoint.baseUrl}${ApiEndpoint.socialLogin}',
              body: requestBody,fromJson: LoginResponseModel.fromJson);
        }, onSuccess: (result) async {
          LoginResponseModel response = result as LoginResponseModel;
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
        }, onError: (error) {
          ApiException apiException = error as ApiException;
          debugPrint('Message: ${apiException.message}');
          debugPrint('Errors: ${apiException.errors}');
          showToast(apiException.message);
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

          await ApiService.instance.apiCall(execute: () async {
            return await ApiService.instance.post(
                '${ApiEndpoint.baseUrl}${ApiEndpoint.socialLogin}',
                body: requestBody,fromJson: LoginResponseModel.fromJson);
          }, onSuccess: (result) async {
            LoginResponseModel response = result as LoginResponseModel;
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
          }, onError: (error) {
            ApiException apiException = error as ApiException;
            debugPrint('Message: ${apiException.message}');
            debugPrint('Errors: ${apiException.errors}');
            showToast(apiException.message);
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
      emailError = 'Invalid email address';
      return;
    }
    loading = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {"email": emailController.text.trim()};

    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance.post(
          '${ApiEndpoint.baseUrl}${ApiEndpoint.forgetPassword}',
          body: requestBody,fromJson: ResetPasswordResponseModel.fromJson);
    }, onSuccess: (result) async {
      ResetPasswordResponseModel response = result as ResetPasswordResponseModel;
      showToast(response.message ?? '');
      Navigator.pop(AppNavigatorKey.key.currentState!.context);
    }, onError: (error) {
      ApiException apiException = error as ApiException;
      debugPrint('Message: ${apiException.message}');
      debugPrint('Errors: ${apiException.errors}');
      showToast(apiException.message);
      setResetPasswordErrorMsg(apiException.errors??{});
    });
    loading = false;
    notifyListeners();
  }

}
