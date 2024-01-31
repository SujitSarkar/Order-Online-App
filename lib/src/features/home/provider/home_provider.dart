import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/Material.dart';
import 'package:order_online_app/core/utils/app_toast.dart';
import 'package:order_online_app/shared/api/api_endpoint.dart';
import 'package:order_online_app/src/features/home/model/settings_data_model.dart';
import 'package:order_online_app/src/features/home/repository/home_repository.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_navigator_key.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();
  bool loading = false;
  bool loadingVideo = false;
  SettingsDataModel? settingsDataModel;
  List<String> sliderImageUrlList = [];

  late CachedVideoPlayerController videoController;

  Future<void> initialize() async {
    loading = true;
    notifyListeners();
    await getSettingsData();
    loading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await getSettingsData();
  }

  void initVideo() {
    if(settingsDataModel?.data!.sliderVidEnable!=null && settingsDataModel?.data!.sliderVidEnable==true){
      loadingVideo = true;
      notifyListeners();
      videoController = CachedVideoPlayerController.network(
          '${ApiEndpoint.imageUrlPath}/${settingsDataModel?.data!.sliderVid ?? ''}');
      videoController.initialize().then((value) {
        videoController.play();
        videoController.setLooping(true);
        loadingVideo = false;
        notifyListeners();
      });
    }
  }

  void disposeVideo() {
    videoController.dispose();
  }

  void navigateToWebPage(String urlPath) {
    disposeVideo();
    final BuildContext context = AppNavigatorKey.key.currentState!.context;
    Navigator.pushNamed(context, AppRouter.webViewPage, arguments: urlPath);
  }

  void popAndNavigateToWebPage(String urlPath, BuildContext context) {
    disposeVideo();
    Scaffold.of(context).closeEndDrawer();
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
        notifyListeners();
      }
    }, onError: (error) {
      showToast(error.toString());
    });
  }
}
