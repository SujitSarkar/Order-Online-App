import 'package:flutter/Material.dart';
import 'package:order_online_app/core/utils/app_toast.dart';
import 'package:order_online_app/shared/api/api_endpoint.dart';
import 'package:order_online_app/src/features/authentication/repository/auth_repository.dart';
import 'package:order_online_app/src/features/home/model/settings_data_model.dart';
import 'package:order_online_app/src/features/home/repository/home_repository.dart';
// import 'package:video_player/video_player.dart';
import '../../../../core/constants/local_storage_key.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_navigator_key.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../../shared/api/api_service.dart';
import '../../authentication/model/login_response_model.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();
  bool loading = false;
  bool loadingVideo = false;
  LoginResponseModel? loginResponseModel;
  SettingsDataModel? settingsDataModel;
  List<String> sliderImageUrlList = [];

  // late VideoPlayerController videoController;

  Future<void> initialize() async {
    loading = true;
    notifyListeners();
    await getLocalData();
    await getSettingsData();
    loading = false;
    notifyListeners();
    debugPrint('HomeProvider initialized');
  }

  Future<void> getLocalData() async {
    loginResponseModel = null;
    final loginResponseFromLocal = await getData(LocalStorageKey.loginResponseKey);
    if (loginResponseFromLocal != null) {
      loginResponseModel = loginResponseModelFromJson(loginResponseFromLocal);
      ApiService.instance.addAccessToken(loginResponseModel?.data?.accessToken);
    }
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await getSettingsData();
  }

  void navigateToWebPage(String urlPath) {
    // disposeVideo();
    final BuildContext context = AppNavigatorKey.key.currentState!.context;
    Navigator.pushNamed(context, AppRouter.webViewPage, arguments: urlPath);
  }

  void popAndNavigateToWebPage(String urlPath, BuildContext context) {
    // disposeVideo();
    Scaffold.of(context).closeDrawer();
    Navigator.pushNamed(context, AppRouter.webViewPage, arguments: urlPath);
  }

  bool canPop() => AppNavigatorKey.key.currentState!.canPop();

  Future<void> getSettingsData() async {
    await _homeRepository.getAppSettings().then(
        (SettingsDataModel? response) async {
      if (response != null) {
        sliderImageUrlList = [];
        settingsDataModel = response;

        //https://api.order-online.digitafact.com/storage/settings/sample/slide1.jpg

        if (settingsDataModel!.data!.sliderImgMobile1 != null &&
            settingsDataModel!.data!.sliderImgMobile1!.isNotEmpty) {
          sliderImageUrlList.add(
              '${ApiEndpoint.imageUrlPath}/${settingsDataModel!.data!.sliderImgMobile1}');
        }
        if (settingsDataModel!.data!.sliderImgMobile2 != null &&
            settingsDataModel!.data!.sliderImgMobile2!.isNotEmpty) {
          sliderImageUrlList.add(
              '${ApiEndpoint.imageUrlPath}/${settingsDataModel!.data!.sliderImgMobile2}');
        }
        if (settingsDataModel!.data!.sliderImgMobile3 != null &&
            settingsDataModel!.data!.sliderImgMobile3!.isNotEmpty) {
          sliderImageUrlList.add(
              '${ApiEndpoint.imageUrlPath}/${settingsDataModel!.data!.sliderImgMobile3}');
        }
        if (settingsDataModel!.data!.sliderImgMobile4 != null &&
            settingsDataModel!.data!.sliderImgMobile4!.isNotEmpty) {
          sliderImageUrlList.add(
              '${ApiEndpoint.imageUrlPath}/${settingsDataModel!.data!.sliderImgMobile4}');
        }
        if (settingsDataModel!.data!.sliderImgMobile5 != null &&
            settingsDataModel!.data!.sliderImgMobile5!.isNotEmpty) {
          sliderImageUrlList.add(
              '${ApiEndpoint.imageUrlPath}/${settingsDataModel!.data!.sliderImgMobile5}');
        }
      }
    }, onError: (error) {
      showToast(error.toString());
    });
    notifyListeners();
  }

  Future<void> logoutButtonOnTap()async{
    await AuthRepository().logout();
    getLocalData();
    notifyListeners();
  }

  // void initVideo() {
  //   if(settingsDataModel?.data!.sliderVidEnable!=null && settingsDataModel?.data!.sliderVidEnable==true){
  //     loadingVideo = true;
  //     notifyListeners();
  //     videoController = VideoPlayerController.networkUrl(
  //         Uri.parse('${ApiEndpoint.imageUrlPath}/${settingsDataModel?.data!.sliderVid ?? ''}'));
  //     videoController.initialize().then((value) {
  //       videoController.play();
  //       videoController.setLooping(true);
  //       loadingVideo = false;
  //       notifyListeners();
  //     });
  //   }
  // }
  //
  // void disposeVideo() {
  //   videoController.dispose();
  // }
}
