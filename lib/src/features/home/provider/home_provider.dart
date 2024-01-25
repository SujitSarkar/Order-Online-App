import 'package:flutter/Material.dart';
import 'package:order_online_app/core/utils/app_toast.dart';
import 'package:order_online_app/shared/api/api_endpoint.dart';
import 'package:order_online_app/src/features/home/model/settings_data_model.dart';
import 'package:order_online_app/src/features/home/repository/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();
  bool loading = false;
  SettingsDataModel? settingsDataModel;
  List<String> sliderImageUrlList = [];

  Future<void> initialize() async {
    await getSettingsData();
  }

  Future<void> getSettingsData() async {
    loading = true;
    notifyListeners();

    await _homeRepository.getAppSettings().then((SettingsDataModel? response) async {
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
    loading = false;
    notifyListeners();
  }
}
