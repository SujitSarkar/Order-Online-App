import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  factory ApiService() {
    return instance;
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App': Platform.isAndroid
        ? 'Android'
        : Platform.isIOS
            ? 'IOS'
            : 'web'
  };

  void addAccessToken(String? token) {
    headers.addEntries({'Authorization': 'Bearer $token'}.entries);
  }

  void clearAccessToken() {
    headers.remove('Authorization');
  }

  Future<void> apiCall(
      {required Function execute,
      required Function(dynamic) onSuccess,
      Function(dynamic)? onError,
      Function? onLoading}) async {
    try {
      if (onLoading != null) onLoading();
      // hide keyboard
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var response = await execute();
      return onSuccess(response);
    } catch (error) {
      if (onError == null) return;
      onError(error);
      return;
    }
  }

  ///get api request
  Future<dynamic> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return _processResponse(response);
  }

  ///post api request
  Future<dynamic> post(String url, {dynamic body}) async {
    http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: body != null ? jsonEncode(body) : null);
    return _processResponse(response);
  }

  ///patch api request
  Future<dynamic> patch(String url, {dynamic body}) async {
    http.Response response = await http.patch(Uri.parse(url),
        headers: headers, body: body != null ? jsonEncode(body) : null);
    return _processResponse(response);
  }

  ///delete api request
  Future<dynamic> delete(String url) async {
    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);
    return _processResponse(response);
  }

  ///check if the response is valid (everything went fine) / else throw error
  dynamic _processResponse(var response) {
    debugPrint('url:- ${response.request?.url}');
    debugPrint('statusCode:- ${response.statusCode}');
    debugPrint('AccessToken:- ${headers['Authorization']}');
    debugPrint('response:- ${response.body}');

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return response;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
