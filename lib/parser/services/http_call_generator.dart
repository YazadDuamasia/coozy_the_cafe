import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../utlis/utlis.dart';

enum HTTPMethod { GET, POST, PUT, DELETE, POST_ENCODE }

class HttpCallGenerator {
  static Future<Map<String, dynamic>> _handleResponse(
      http.Response response) async {
    if (response.statusCode == 429) {
      return await _handleResponse(response);
    } else if (response.statusCode != 200) {
      return {"isError": true, "response": "Something went wrong."};
    } else {
      final jsonResponse = json.decode(response.body);
      return {"isError": false, "response": jsonResponse};
    }
  }

  static Future<Map<String, dynamic>> makeHttpRequest({
    required String? url,
    String? headers,
    String? params,
    HTTPMethod method = HTTPMethod.GET,
  }) async {
    try {
      final uri = Uri.parse(url ?? "");
      late http.Response response;

      var headerMap;
      if (headers != null || headers!.isNotEmpty) {
        headerMap = convert.json.decode(headers);
      }

      var bodyMap;
      if (params != null || params!.isNotEmpty) {
        bodyMap = convert.json.decode(params);
      }

      switch (method) {
        case HTTPMethod.GET:
          uri.replace(queryParameters: bodyMap);

          String curl = await generateCurlCommandForPost(
              url: uri.toString(),
              header: headerMap,
              method: "GET",
              params: null);
          Constants.debugLog(HttpCallGenerator, curl);
          response = await http
              .get(
                uri,
                headers: headerMap,
              )
              .timeout(const Duration(seconds: 15),
                  onTimeout: () => throw TimeoutException(
                      "The connection has timed out, Please try again!"));
          break;
        case HTTPMethod.POST:
          String curl = await generateCurlCommandForPost(
              url: uri.toString(),
              header: headerMap,
              method: "POST",
              params: bodyMap);
          Constants.debugLog(HttpCallGenerator, curl);
          response = await http
              .post(uri, headers: headerMap, body: bodyMap)
              .timeout(const Duration(seconds: 15),
                  onTimeout: () => throw TimeoutException(
                      "The connection has timed out, Please try again!"));
          {}
          break;
        case HTTPMethod.POST_ENCODE:
          String curl = await generateCurlCommandForPost(
              url: uri.toString(),
              header: headerMap,
              method: "POST",
              params: bodyMap);
          Constants.debugLog(HttpCallGenerator, curl);
          response = await http
              .post(uri,
                  headers: headerMap,
                  body: bodyMap,
                  encoding: convert.Encoding.getByName("utf-8"))
              .timeout(const Duration(seconds: 15),
                  onTimeout: () => throw TimeoutException(
                      "The connection has timed out, Please try again!"));
          break;
        case HTTPMethod.PUT:
          String curl = await generateCurlCommandForPost(
              url: uri.toString(),
              header: headerMap,
              method: "PUT",
              params: bodyMap);
          Constants.debugLog(HttpCallGenerator, curl);
          response = await http
              .put(uri, headers: headerMap, body: bodyMap)
              .timeout(const Duration(seconds: 15),
                  onTimeout: () => throw TimeoutException(
                      "The connection has timed out, Please try again!"));
          break;
        case HTTPMethod.DELETE:
          String curl = await generateCurlCommandForPost(
              url: uri.toString(),
              header: headerMap,
              method: "DELETE",
              params: bodyMap);
          Constants.debugLog(HttpCallGenerator, curl);
          response = await http
              .delete(uri, headers: headerMap, body: bodyMap)
              .timeout(const Duration(seconds: 15),
                  onTimeout: () => throw TimeoutException(
                      "The connection has timed out, Please try again!"));
          break;

        default:
          throw Exception("Unsupported HTTP method: $method");
      }

      return await _handleResponse(response);
    } on TimeoutException {
      return {
        "isError": true,
        "response": "The connection has timed out. Please try again."
      };
    } on SocketException {
      return {
        "isError": true,
        "response":
            "No Internet Connection. Please check your internet connection."
      };
    } catch (e) {
      return {"isError": true, "response": "Something went wrong."};
    }
  }

  static Future<dynamic> callPostFileUploadApi({
    required String? url,
    required String? header,
    required String? params,
    required String? filepath,
    required String? fileParmenter,
  }) async {
    Constants.debugLog(HttpCallGenerator, "callPostFileUploadApi:url:$url");
    Constants.debugLog(
        HttpCallGenerator, "callPostFileUploadApi:params:$params");
    Constants.debugLog(
        HttpCallGenerator, "callPostFileUploadApi:filename:$filepath");

    final bodyMap = convert.json.decode(params!);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url!));
      request.files.add(http.MultipartFile(fileParmenter!,
          File(filepath!).readAsBytes().asStream(), File(filepath).lengthSync(),
          filename: filepath.split("/").last));
      http.Response response =
          await http.Response.fromStream(await request.send()).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
            'The connection has timed out, Please try again!'),
      );

      if (response.statusCode == 429) {
        //server is busy.
        await callPostFileUploadApi(
            url: url,
            header: header,
            params: params,
            filepath: filepath,
            fileParmenter: fileParmenter);
      } else if (response.statusCode != 200) {
        Map<String, dynamic> result = {
          "isError": true,
          "response": "Something when wrong."
        };
        return result;
      } else {
        if (response.body.isEmpty) {
          Map<String, dynamic> result = {
            "isError": true,
            "response": "Something when wrong."
          };
          return result;
        } else {
          var jsonResponse = convert.jsonDecode(response.body);
          Map<String, dynamic> result = {
            "isError": false,
            "response": jsonResponse
          };
          return result;
        }
      }
    } on TimeoutException {
      // A timeout occurred.
      Map<String, dynamic> result = {
        "isError": true,
        "response": "The connection has timed out, Please try again!"
      };
      return result;
    } on SocketException {
      Map<String, dynamic> result = {
        "isError": true,
        "response":
            "No Internet Connection.Please Check your internet Connection."
      };
      return result;
    } on Exception {
      Map<String, dynamic> result = {
        "isError": true,
        "response": "Something when wrong."
      };
      return result;
    }
  }

  static Future<String> generateCurlCommandForPost(
      {String? url, String? method, String? header, String? params}) async {
    final headerMap = convert.json.decode(header ?? "");
    final headerString = headerMap.entries
        .map((entry) => "-H '${entry.key}: ${entry.value}'")
        .join(" ");

    final paramsMap = convert.json.decode(params ?? "");
    final paramsString = paramsMap.entries
        .map((entry) => "-d '${entry.key}=${entry.value}'")
        .join(" ");

    return 'curl -X ${method == null ? "GET" : method.toUpperCase()} $headerString $paramsString $url';
  }
}
