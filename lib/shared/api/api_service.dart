import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'app_exceptions.dart';
import 'error_handler.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  factory ApiService() {
    return instance;
  }

  Map<String, String> headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
    'app': 'android'
  };

  void addAccessToken(String? token) {
    headers.addEntries({'Authorization': 'Bearer $token'}.entries);
  }

  Future<void> apiCall(
      {required Function execute,
      required Function(dynamic) onSuccess,
      Function(dynamic)? onError,
      Function? onLoading}) async {
    try {
      if (onLoading != null) onLoading();
      // hide keyboard
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
      //execute function that user passed
      var response = await execute();
      return onSuccess(response);
    } catch (error) {
      ErrorHandler.handleError(error);
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
    http.Response response = await http.delete(Uri.parse(url),headers: headers);
    return _processResponse(response);
  }

  ///check if the response is valid (everything went fine) / else throw error
  dynamic _processResponse(var response) {
    debugPrint('url:- ${response.request?.url}');
    debugPrint('statusCode:- ${response.statusCode}');
    debugPrint('AccessToken:- ${headers['Authorization']}');
    // debugPrint('response:- ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response;
      case 400:
        throw BadRequestException('Invalid credentials');
      case 404:
        throw InvalidCredentialsException('Invalid credentials');
      case 401:
        throw UnauthorizedException('Unauthorized request');
      //implement logout
      case 403:
        throw UnauthorizedException('Unauthorized request');
      case 417:
        throw ExpectationException(
            'There is no public email found for this user');
      case 409:
        throw UnauthorizedException('Duplicate credential');
      case 500:
        throw DataParsingException('Internal server error');
      default:
        throw DataParsingException('Something went wrong');
    }
  }
}
