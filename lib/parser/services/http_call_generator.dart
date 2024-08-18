import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:http/http.dart' as http;


enum HTTPMethod { GET, POST, PUT, DELETE, POST_ENCODE }

class HttpCallGenerator {
static const int maxRetries = 3; // Maximum number of retries
  static const Duration retryDelay = Duration(seconds: 5); // Delay between retries

  static Future<Map<String, dynamic>?> makeHttpRequest({
    required String url,
    Map<String, String>? headers,
    String? params,
    HTTPMethod method = HTTPMethod.GET,
  }) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        final uri = Uri.parse(url);
        http.Response? response;
        var bodyMap;

        if (params != null && params.isNotEmpty) {
          bodyMap = convert.json.decode(params);
        } else {
          bodyMap = null;
        }

        switch (method) {
          case HTTPMethod.GET:
            response = await http
                .get(uri, headers: headers)
                .timeout(const Duration(seconds: 15));
            break;
          case HTTPMethod.POST:
            response = await http
                .post(uri, headers: headers, body: bodyMap)
                .timeout(const Duration(seconds: 15));
            break;
          case HTTPMethod.POST_ENCODE:
            response = await http
                .post(
                  uri,
                  headers: headers,
                  body: bodyMap,
                  encoding: convert.Encoding.getByName("utf-8"),
                )
                .timeout(const Duration(seconds: 15));
            break;
          case HTTPMethod.PUT:
            response = await http
                .put(uri, headers: headers, body: bodyMap)
                .timeout(const Duration(seconds: 15));
            break;
          case HTTPMethod.DELETE:
            response = await http
                .delete(uri, headers: headers, body: bodyMap)
                .timeout(const Duration(seconds: 15));
            break;
          default:
            throw Exception("Unsupported HTTP method: $method");
        }

        final result = await _handleResponse(response);
        if (result != null && result["isError"] == true && result["response"] == "Too many requests. Please try again later.") {
          // Increment retry count and wait before retrying
          retryCount++;
          await Future.delayed(retryDelay);
        } else {
          // If no error or error is not related to rate limiting, return the result
          return result;
        }
      } on TimeoutException catch (e) {
        return {
          "isError": true,
          "errorType": "TimeoutException",
          "response": "The connection has timed out. Please try again later.",
          "details": e.toString()
        };
      } on FormatException catch (e) {
        return {
          "isError": true,
          "errorType": "FormatException",
          "response":
              "Bad response format. The server returned invalid data. Please try again and if not solve please contact us.",
          "details": e.toString()
        };
      } on http.ClientException catch (e) {
        return {
          "isError": true,
          "errorType": "ClientException",
          "response":
              "The server returned invalid data. Please try again and if not solve please contact us.",
          "details": e.toString()
        };
      } catch (e) {
        return {
          "isError": true,
          "errorType": "GeneralException",
          "response": "Something went wrong.",
          "details": e.toString()
        };
      }
    }

    // If maximum retries reached, return an error response
    return {
      "isError": true,
      "response": "Maximum retries reached. The server is still rate limiting."
    };
  }

  static Future<Map<String, dynamic>?> _handleResponse(
      http.Response? response) async {
    if (response != null) {
      switch (response.statusCode) {
        case 200:
          // OK
          try {
            return {"isError": false, "response": response.body};
          } catch (e) {
            return {
              "isError": true,
              "errorType": "FormatException",
              "response": "The server returned invalid data. Please try again and if not solve please contact us.",
              "details": e.toString()
            };
          }

        case 429:
          // Too Many Requests
          return {
            "isError": true,
            "response": "Too many requests. Please try again later."
          };

        case 400:
          // Bad Request
          return {
            "isError": true,
            "response": "Bad request. The server could not understand the request."
          };

        case 401:
          // Unauthorized
          return {
            "isError": true,
            "response": "Unauthorized. Please check your credentials."
          };

        case 403:
          // Forbidden
          return {
            "isError": true,
            "response": "Forbidden. You do not have permission to access this resource."
          };

        case 404:
          // Not Found
          return {
            "isError": true,
            "response": "Not found. The requested resource could not be found."
          };

        case 500:
          // Internal Server Error
          return {
            "isError": true,
            "response": "Internal server error. Please try again later."
          };

        default:
          // Other unexpected status codes
          return {
            "isError": true,
            "response": "Request failed with status: ${response.statusCode}."
          };
      }
    } else {
      // Response is null
      return {
        "isError": true,
        "response": "No response from the server."
      };
    }
  }
} 