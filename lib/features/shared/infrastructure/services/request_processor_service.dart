// services/request_processor_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../config/constants/environment.dart';
import '../../../local_storage/local_storage.dart';

class RequestProcessorService {
  final http.Client client;

  final apiUrl = Environment.apiUrl;

  RequestProcessorService({http.Client? client})
    : client = client ?? http.Client();

  Future<ProcessResult> processRequest(RequestApi request, String token) async {
    try {
      // Prepare headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        ...?request.headers?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      };

      // Prepare body
      final body = request.body != null ? jsonEncode(request.body) : null;

      // Make the HTTP request
      final response = await _makeRequest(
        method: request.method,
        url: '${request.url}/token=$token',  // If token is to be sent as query para m
        headers: headers,
        body: body,
      );

      // Check if request was successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ProcessResult.success(response);
      } else {
        return ProcessResult.failure(
          'HTTP ${response.statusCode}: ${response.body}',
          response: response,
        );
      }
    } catch (e, stackTrace) {
      return ProcessResult.failure(e.toString(), stackTrace: stackTrace);
    }
  }

  Future<http.Response> _makeRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    required String? body,
  }) async {
    switch (method.toUpperCase()) {
      case 'GET':
        return await client.get(Uri.parse(url), headers: headers);
      case 'POST':
        return await client.post(Uri.parse(url), headers: headers, body: body);
      case 'PUT':
        return await client.put(Uri.parse(url), headers: headers, body: body);
      case 'PATCH':
        return await client.patch(Uri.parse(url), headers: headers, body: body);
      case 'DELETE':
        return await client.delete(Uri.parse(url), headers: headers);
      default:
        throw UnsupportedError('HTTP method $method is not supported');
    }
  }

  void dispose() {
    client.close();
  }
}

class ProcessResult {
  final bool isSuccess;
  final String? error;
  final http.Response? response;
  final StackTrace? stackTrace;

  ProcessResult.success(this.response)
    : isSuccess = true,
      error = null,
      stackTrace = null;

  ProcessResult.failure(this.error, {this.response, this.stackTrace})
    : isSuccess = false;
}
