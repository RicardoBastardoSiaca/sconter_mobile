import 'dart:math';

import 'package:dio/dio.dart';
import 'dart:convert';




import '../../../../config/constants/environment.dart';
import '../../../local_storage/local_storage.dart';
import 'services.dart';

class RequestProcessor {
  static const int maxRetries = 3;
  static const Duration timeout = Duration(seconds: 30);
  final String accessToken;
  
  // Dio instance with default configuration (initialized per instance to use accessToken)
  late final Dio _dio;

  RequestProcessor({required this.accessToken}) {
    _dio = Dio(BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {'Authorization': 'Bearer $accessToken'},
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
    ));
    addInterceptors();
  }
  // Process a single request
  Future<bool> processRequest(RequestApi request, localStorageRepository
  ) async {
    try {
      // Mark as processing
      final processingRequest = request.copyWith(isProcessing: true);
      // TODO: Update in your local database
      // await _updateRequestInDb(processingRequest);

      // Prepare options
      final options = Options(
        method: request.method.toLowerCase(),
        headers: (() {
          try {
            if (request.headers == null) return null;
            if (request.headers is Map<String, dynamic>) return request.headers as Map<String, dynamic>;
            return json.decode(request.headers as String) as Map<String, dynamic>?;
          } catch (e) {
            return null;
          }
        })(),
      );

      Response response;

      // Handle multipart requests separately
      // if (request.isMultipart && request.files != null && request.files!.isNotEmpty) {
      if (request.isMultipart) {
        response = await _processMultipartRequest(request);
      } else {
        // Handle regular requests
        response = await _processRegularRequest(request, options);
      }

      // Check if request was successful
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Request successful - remove from queue and clean up files
        await _cleanupRequestFiles(request);
        await _deleteRequestFromDb(request.id, localStorageRepository);
        print('Request ${request.id} completed successfully with status ${response.statusCode}');
        return true;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (dioError) {
      print('Dio error processing request ${request.id}: ${dioError.message}');
      return _handleRetry(request, dioError);
    } catch (e) {
      print('Unexpected error processing request ${request.id}: $e');
      return _handleRetry(request, null);
    }
  }

  // Process regular request (non-multipart)
  Future<Response> _processRegularRequest(RequestApi request, Options options) async {
    switch (request.method.toUpperCase()) {
      case 'GET':
        return await _dio.get(
            '${request.url}/?token=$accessToken ',
            options: options,
          );
      case 'POST':
        return await _dio.post(
             '${request.url}/?token=$accessToken ',
            data: stringToMap(request.body),
            options: options,
          );
      case 'PUT':
        return await _dio.put(
             '${request.url}/?token=$accessToken ',
            data: request.body,
            options: options,
          );
      case 'DELETE':
        return await _dio.delete(
             '${request.url}/?token=$accessToken ',
            data: request.body,
            options: options,
          );
      case 'PATCH':
        return await _dio.patch(
             '${request.url}/?token=$accessToken ',
            data: request.body,
            options: options,
          );
      default:
        throw Exception('Unsupported HTTP method: ${request.method}');
    }
  }

  // Process multipart request
  Future<Response> _processMultipartRequest(RequestApi request) async {
   final formData = FormData();

    // Log request details
    print('📦 Multipart request details:');
    print('  URL: ${request.url}');
    print('  Files: ${request.files!.length}');
    print('  Body fields: ${request.body != null ? (request.body as Map).length : 0}');

    // Add regular fields from body
    if (request.body is Map<String, dynamic>) {
      final bodyMap = request.body as Map<String, dynamic>;
      bodyMap.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
          print('  📋 Field: $key = $value');
        }
      });
    }

    // Add files to form data with safe MIME type handling
    for (final file in request.files!) {
      final fileSize = await file.getFileSize();
      print('  📄 Adding file: ${file.fileName} (${fileSize / 1024} KB) - Field: ${file.fieldName}');

      try {
        // Safely parse the MIME type with fallback
        final mediaType = FileStorageManager.safeParseMediaType(file.mimeType);
        
        print('  📧 MIME Type: ${file.mimeType} -> Parsed: $mediaType');

        final multipartFile = await MultipartFile.fromFile(
          file.filePath,
          filename: file.fileName,
          contentType: mediaType,
        );

        formData.files.add(MapEntry(
          file.fieldName,
          multipartFile,
        ));
        
        print('  ✅ File added successfully');
      } catch (e) {
        print('❌ Error creating multipart file for ${file.fileName}: $e');
        
        // Fallback: create multipart file without content type
        try {
          final multipartFile = await MultipartFile.fromFile(
            file.filePath,
            filename: file.fileName,
            // Omit contentType if it's causing issues
          );

          formData.files.add(MapEntry(
            file.fieldName,
            multipartFile,
          ));
          
          print('  ✅ File added with fallback (no content type)');
        } catch (fallbackError) {
          print('❌ Fallback also failed for ${file.fileName}: $fallbackError');
          rethrow; // Re-throw if fallback also fails
        }
      }
    }

    // Prepare headers (remove Content-Type for multipart)
    final headers = <String, dynamic>{
      ...?request.headers,
    };
    
    // Ensure we don't have conflicting Content-Type header
    headers.remove('Content-Type');
    headers.remove('content-type');

    print('🚀 Sending multipart request...');
    

    // response = await _dio.post(
//              '${request.url}/?token=$accessToken ',
//             data: stringToMap(request.body),
//             options: options,
//           );

    try {
      
      final options = Options(
        method: request.method.toLowerCase(),
        headers: request.headers,
      );
      final response = await _dio.post(
       '${request.url}/?token=$accessToken ',
        data: formData,
        options: options,
      );
      
      // ********************************************************************************************************
      // TODO: REVISAR MAÑANA LA DATA QUE SE ESTA ENVIANDO, PARA QUE HAGA MATCH CON LA LLAMADA DE UPLOADIMAGE
      // ********************************************************************************************************
      
      print('✅ Multipart request sent successfully');

      // Delete
      
      return response;
    } catch (e) {
      print('❌ Error sending multipart request: $e');
      rethrow;
    }
  }

// _deleteRequestFromDb
  Future<void> _deleteRequestFromDb(int requestId, localStorageRepository) async {
    try {
      await localStorageRepository.deleteApiRequestApi(requestId);
    } catch (e) {
      print('Error deleting RequestApi from DB: $e');
    }
  }


  

  // Clean up files after successful request
  Future<void> _cleanupRequestFiles(RequestApi request) async {
    if (request.files != null) {
      for (final file in request.files!) {
        await FileStorageManager.deleteFile(file.filePath);
      }
    }
  }

  // Handle retry logic (same as before with minor adjustments)
  Future<bool> _handleRetry(RequestApi request, DioException? error) async {
    // Increment retry count
    final updatedRequest = request.copyWith(
      retryCount: request.retryCount + 1,
      isProcessing: false,
    );
    
    // TODO: Update in your local database
    // await _updateRequestInDb(updatedRequest);

    // Check if we should retry
    if (request.retryCount < maxRetries) {
      print('Will retry request ${request.id} (${request.retryCount + 1}/$maxRetries)');
      
      // Optional: Exponential backoff
      final delay = Duration(seconds: pow(2, request.retryCount).toInt());
      await Future.delayed(delay);
      
      return false;
    } else {
      print('Max retries exceeded for request ${request.id}');
      // Clean up files even if request fails after max retries
      await _cleanupRequestFiles(request);
      return false;
    }
  }

  // Process all pending requests (same as before)
  Future<void> processAllRequests(List<RequestApi> requests, localStorageRepository) async {
    final pendingRequests = requests.where((req) => !req.isProcessing).toList();
    pendingRequests.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    print('Processing ${pendingRequests.length} pending requests...');

    for (final request in pendingRequests) {
      try {
        await processRequest(request, localStorageRepository);
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        print('Failed to process request ${request.id}: $e');
      }
    }
    
    print('Finished processing all requests');
  }

  // Add interceptors (same as before)
  void addInterceptors() {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (log) => print('Dio: $log'),
    ));
  }

  void cancelAllRequests() {
    _dio.close(force: true);
  }
}

// class RequestProcessor {
//   static const int maxRetries = 3;
//   static const Duration timeout = Duration(seconds: 30);
//   final String accessToken;
//   // local storage repository

//   // Dio instance with default configuration (initialized per instance to use accessToken)
//   late final Dio _dio;

//   RequestProcessor({required this.accessToken}) {
//     _dio = Dio(BaseOptions(
//       baseUrl: Environment.apiUrl,
//       headers: {'Authorization': 'Bearer $accessToken'},
//       connectTimeout: timeout,
//       receiveTimeout: timeout,
//       sendTimeout: timeout,
//     ));
//     addInterceptors();
//   }

//   // Process a single request
//   Future<bool> processRequest(RequestApi request, localStorageRepository) async {
//     try {
//       // Mark as processing
//       final processingRequest = request.copyWith(isProcessing: true);
//       // TODO: Update in your local database
//       // await _updateRequestInDb(processingRequest);

//       // Prepare options
//       final options = Options(
//         method: request.method.toLowerCase(),
//         headers: request.headers,
//       );

//       Response response;

//       // Make the API call using Dio
//       switch (request.method.toUpperCase()) {
//         case 'GET':
//           response = await _dio.get(
//             '${request.url}/?token=$accessToken ',
//             options: options,
//           );
//           break;
//         case 'POST':
//         try {
//           response = await _dio.post(
//              '${request.url}/?token=$accessToken ',
//             data: stringToMap(request.body),
//             options: options,
//           );
//           print('Response: $response');
//           print('POST request for ${request.url} completed with status ${response.statusCode}');
//         } catch (e) {
//           print('Error in POST request for ${request.url}: $e');
//           rethrow;
//         }
//           break;
//         case 'PUT':
//           response = await _dio.put(
//              '${request.url}/?token=$accessToken ',
//             data: request.body,
//             options: options,
//           );
//           break;
//         case 'DELETE':
//           response = await _dio.delete(
//              '${request.url}/?token=$accessToken ',
//             data: request.body,
//             options: options,
//           );
//           break;
//         case 'PATCH':
//           response = await _dio.patch(
//              '${request.url}/?token=$accessToken ',
//             data: request.body,
//             options: options,
//           );
//           break;
//         default:
//           throw Exception('Unsupported HTTP method: ${request.method}');
//       }

//       // Check if request was successful
//       if (response.statusCode! >= 200 && response.statusCode! < 300) {
//         // Request successful - remove from queue or mark as completed
//         // await _deleteRequestFromDb(request.id);
//         print('Request ${request.id} completed successfully with status ${response.statusCode}');
//         // delete the request from local storage
//         await localStorageRepository.deleteApiRequestApi(request.id);

//         return true;
//       } else {
//         // Request failed - increment retry count
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//         );
//       }
//     } on DioException catch (dioError) {
//       print('Dio error processing request ${request.id}: ${dioError.message}');
      
//       // Handle specific Dio error types
//       if (dioError.type == DioExceptionType.connectionTimeout ||
//           dioError.type == DioExceptionType.sendTimeout ||
//           dioError.type == DioExceptionType.receiveTimeout) {
//         print('Timeout error for request ${request.id}');
//       } else if (dioError.type == DioExceptionType.badResponse) {
//         print('Bad response for request ${request.id}: ${dioError.response?.statusCode}');
//       } else if (dioError.type == DioExceptionType.connectionError) {
//         print('Connection error for request ${request.id}');
//       }
      
//       return _handleRetry(request, dioError);
//     } catch (e) {
//       print('Unexpected error processing request ${request.id}: $e');
//       return _handleRetry(request, null);
//     }
//   }

//   // Handle retry logic
//   Future<bool> _handleRetry(RequestApi request, DioException? error) async {
//     // Increment retry count
//     final updatedRequest = request.copyWith(
//       retryCount: request.retryCount + 1,
//       isProcessing: false,
//     );
    
//     // TODO: Update in your local database
//     // await _updateRequestInDb(updatedRequest);

//     // Check if we should retry
//     if (request.retryCount < maxRetries) {
//       print('Will retry request ${request.id} (${request.retryCount + 1}/$maxRetries)');
      
//       // Optional: Exponential backoff
//       final delay = Duration(seconds: pow(2, request.retryCount).toInt());
//       await Future.delayed(delay);
      
//       return false;
//     } else {
//       print('Max retries exceeded for request ${request.id}');
//       // TODO: You might want to move this to a failed requests table
//       // or notify the user
//       return false;
//     }
//   }

//   // Process all pending requests sequentially
//   Future<void> processAllRequests(List<RequestApi> requests, localStorageRepository) async {
//     // Filter out requests that are already being processed
//     final pendingRequests = requests.where((req) => !req.isProcessing).toList();
    
//     // Sort by timestamp (oldest first)
//     pendingRequests.sort((a, b) => a.timestamp.compareTo(b.timestamp));

//     print('Processing ${pendingRequests.length} pending requests...');

//     // Process requests sequentially to avoid overwhelming the server
//     for (final request in pendingRequests) {
//       try {
        
        
//         await processRequest(request, localStorageRepository);
        
//         // Small delay between requests to be gentle on the server
//         await Future.delayed(const Duration(milliseconds: 100));


//       } catch (e) {
//         print('Failed to process request ${request.id}: $e');
//         // Continue with next request even if one fails
//       }
//     }
    
//     print('Finished processing all requests');
//   }

//   // Process requests in batches with concurrent execution
//   Future<void> processRequestsInBatches(
//     List<RequestApi> requests, localStorageRepository, {
//     int batchSize = 5,
//   }) async {
//     final pendingRequests = requests.where((req) => !req.isProcessing).toList();
//     pendingRequests.sort((a, b) => a.timestamp.compareTo(b.timestamp));

//     for (int i = 0; i < pendingRequests.length; i += batchSize) {
//       final batch = pendingRequests.sublist(
//         i,
//         i + batchSize > pendingRequests.length 
//             ? pendingRequests.length 
//             : i + batchSize,
//       );

//       // Process batch concurrently using Dio's built-in concurrency
//       final results = await Future.wait(
//         batch.map((request) => processRequest(request, localStorageRepository)),
//         eagerError: false, // Continue even if some requests fail
//       );

//       final successfulCount = results.where((result) => result == true).length;
//       print('Batch completed: $successfulCount/${batch.length} successful');

//       // Delay between batches
//       if (i + batchSize < pendingRequests.length) {
//         await Future.delayed(const Duration(seconds: 1));
//       }
//     }
//   }

//   // Cancel all ongoing requests (useful when app closes)
//   void cancelAllRequests() {
//     _dio.close(force: true);
//   }

//   // Add interceptors for logging, authentication, etc.
//   void addInterceptors() {
//     _dio.interceptors.add(LogInterceptor(
//       requestBody: true,
//       responseBody: true,
//       logPrint: (log) => print('Dio: $log'),
//     ));

//     // Add auth interceptor if needed
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         // Ensure the instance token is present on every request
//         options.headers['Authorization'] = 'Bearer $accessToken';
//         return handler.next(options);
//       },
//       onError: (error, handler) {
//         // Handle authentication errors globally
//         if (error.response?.statusCode == 401) {
//           // Handle token refresh or logout
//           print('Authentication error: 401 Unauthorized');
//         }
//         return handler.next(error);
//       },
//     ));
//   }
// }


// Map<String, dynamic>? stringToMap(String? jsonString) {
//   try {
//     if (jsonString == null || jsonString.isEmpty) {
//       return null;
//     }
//     // Decode JSON string to Map using dart:convert
//     final Map<String, dynamic> map = json.decode(jsonString);
//     return map;
//   } catch (e) {
//     // Handle JSON decoding errors
//     return null;
//   }
// }