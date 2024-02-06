import 'package:flutter/material.dart';
import 'package:order_online_app/core/utils/app_toast.dart';
import 'package:order_online_app/shared/api/api_endpoint.dart';
import 'package:order_online_app/shared/api/api_service.dart';
import 'package:order_online_app/src/features/home/model/settings_data_model.dart';

class HomeRepository {
  Future<SettingsDataModel?> getAppSettings() async {
    SettingsDataModel? result;
    await ApiService.instance.apiCall(execute: () async {
      return await ApiService.instance
          .get('${ApiEndpoint.baseUrl}${ApiEndpoint.settings}');
    }, onSuccess: (response) async {
      debugPrint(response.body);
      result = settingsDataModelFromJson(response.body);
    }, onError: (error) {
      debugPrint(error.message ?? 'Something went wrong');
      showToast(error.message ?? 'Something went wrong');
    });
    return result;
  }
}
