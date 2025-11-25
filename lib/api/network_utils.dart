import 'dart:convert';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/api/api_routes.dart';
import 'package:open_core_hr/main.dart';

import '../models/api_response_model.dart';
import '../utils/app_constants.dart';
import 'config.dart';

Map<String, String> buildHeader() {
  String? token = getStringAsync(tokenPref);

  Map<String, String> headers = {};

  if (!token.isEmptyOrNull) {
    headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  } else {
    headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  return headers;
}

String getBaseUrl() {
  var baseUrl = getStringAsync('baseurl');
  if (baseUrl == '') {
    return APIRoutes.baseURL;
  } else {
    return '${baseUrl}api/V1/';
  }
}

Future<Response> postRequest(String endPoint, body) async {
  try {
    endPoint = getBaseUrl() + endPoint;
    if (!await isNetworkAvailable()) throw noInternetMsg;

    log('Request: $endPoint $body');

    Response response = await post(Uri.parse(endPoint),
            body: jsonEncode(body), headers: buildHeader())
        .timeout(const Duration(seconds: timeoutDuration),
            onTimeout: () => throw language.lblPleaseTryAgain);

    log('Response: $endPoint ${response.statusCode} ${response.body.toString()}');
    return response;
  } catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw noInternetMsg;
    } else {
      throw 'Something went wrong';
    }
  }
}

Future<Response> getRequest(String endPoint) async {
  try {
    endPoint = getBaseUrl() + endPoint;
    if (!await isNetworkAvailable()) throw noInternetMsg;

    log('Request: $endPoint ');

    Response response = await get(Uri.parse(endPoint), headers: buildHeader())
        .timeout(const Duration(seconds: timeoutDuration),
            onTimeout: () => throw language.lblPleaseTryAgain);

    log('Response: $endPoint ${response.statusCode} ${response.body.toString()}');
    return response;
  } catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw noInternetMsg;
    } else {
      toast(language.lblPleaseTryAgain);
      throw language.lblPleaseTryAgain;
    }
  }
}

Future<Response> getRequestWithQuery(String endPoint, String query) async {
  try {
    endPoint = getBaseUrl() + endPoint;
    if (!await isNetworkAvailable()) throw noInternetMsg;

    String url = '$endPoint?$query';

    log('Request: $endPoint?$query ');

    Response response = await get(Uri.parse(url), headers: buildHeader())
        .timeout(const Duration(seconds: timeoutDuration),
            onTimeout: () => throw language.lblPleaseTryAgain);

    log('Response: $endPoint?$query ${response.statusCode} ${response.body.toString()}');
    log(response.body);
    return response;
  } catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw noInternetMsg;
    } else {
      toast(language.lblPleaseTryAgain);
      throw language.lblPleaseTryAgain;
    }
  }
}

Future<bool> multipartRequest(String endPoint, String filePath) async {
  try {
    endPoint = getBaseUrl() + endPoint;
    if (!await isNetworkAvailable()) throw noInternetMsg;

    MultipartRequest request = MultipartRequest('POST', Uri.parse(endPoint));

    MultipartFile file = await MultipartFile.fromPath("file", filePath);

    request.files.add(file);

    request.headers.addAll(buildHeader());

    log("Multipart Request: $request");

    var response = await request.send();

    var responseBody = await response.stream.bytesToString();

    log('"Multipart Response: $endPoint Status ${response.statusCode}} Date: $responseBody');

    return response.statusCode == 200;
  } catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw noInternetMsg;
    } else {
      toast(language.lblPleaseTryAgain);
      throw language.lblPleaseTryAgain;
    }
  }
}

Future<StreamedResponse> multipartRequestWithData(
    String endPoint, String filePath, Map<String, String> data) async {
  try {
    endPoint = getBaseUrl() + endPoint;
    if (!await isNetworkAvailable()) throw noInternetMsg;

    MultipartRequest request = MultipartRequest('POST', Uri.parse(endPoint));

    request.fields.addAll(data);

    MultipartFile file = await MultipartFile.fromPath("file", filePath);

    request.files.add(file);

    request.headers.addAll(buildHeader());

    log("Multipart Request: $request");

    var response = await request.send();

    log('"Multipart Response: $endPoint Status ${response.statusCode}}');

    return response;
  } catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw noInternetMsg;
    } else {
      toast(language.lblPleaseTryAgain);
      throw language.lblPleaseTryAgain;
    }
  }
}

Future<ApiResponseModel?> handleResponse(Response response) async {
  if (response.statusCode.isSuccessful()) {
    var resModel = ApiResponseModel.fromJson(jsonDecode(response.body));
    return resModel;
  } else if (response.statusCode == 401) {
    sharedHelper.logoutAlt();
    throw ('Please login again');
  } else if (response.statusCode == 400) {
    var resModel = ApiResponseModel.fromJson(jsonDecode(response.body));
    return resModel;
  } else {
    return null;
  }
}
