import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/constants/app_constants.dart';
import '../exceptions/network_exception.dart';
import '../utils/logger.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  ApiClient({http.Client? client, this.baseUrl = AppConstants.baseUrl})
    : _client = client ?? http.Client();

  Future get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);

      AppLogger.log('GET: $uri', 'API');

      final response = await _client
          .get(uri)
          .timeout(AppConstants.timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException.noInternet();
    } on TimeoutException {
      throw NetworkException.timeout();
    } on NetworkException {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error('GET request failed', e, stackTrace);
      throw NetworkException(
        message: 'Request failed: ${e.toString()}',
        type: NetworkExceptionType.unknown,
      );
    }
  }

  Future post(String endpoint, {Map? body}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      AppLogger.log('POST: $uri', 'API');

      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(AppConstants.timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException.noInternet();
    } on TimeoutException {
      throw NetworkException.timeout();
    } on NetworkException {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error('POST request failed', e, stackTrace);
      throw NetworkException(
        message: 'Request failed: ${e.toString()}',
        type: NetworkExceptionType.unknown,
      );
    }
  }

  dynamic _handleResponse(http.Response response) {
    AppLogger.log('Response: ${response.statusCode}', 'API');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        // log("status code  is 200 and response is ${response.body}");

        return json.decode(response.body);
      } catch (e) {
        throw NetworkException.parseError();
      }
    } else if (response.statusCode == 404) {
      throw NetworkException.notFound();
    } else if (response.statusCode == 401) {
      throw NetworkException.unauthorized();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw NetworkException.badRequest();
    } else {
      throw NetworkException.serverError(response.statusCode);
    }
  }

  void dispose() {
    _client.close();
  }
}
