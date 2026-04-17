import 'dart:io';

class RequestApi {
  final int id;
  final String url;
  final String method; // 'GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'MULTIPART'
  final Map<String, dynamic>? headers;
  final dynamic body;
  final int timestamp;
  final int retryCount;
  final bool isProcessing;
  final List<RequestFile>? files; // Added for file support
  final bool isMultipart; // Flag to indicate multipart request

  RequestApi({
    required this.id,
    required this.url,
    required this.method,
    this.headers,
    this.body,
    required this.timestamp,
    this.retryCount = 0,
    this.isProcessing = false,
    this.files,
    this.isMultipart = false,
  });

  // Copy with method for updating properties
  RequestApi copyWith({
    int? id,
    String? url,
    String? method,
    Map<String, dynamic>? headers,
    dynamic body,
    int? timestamp,
    int? retryCount,
    bool? isProcessing,
    List<RequestFile>? files,
    bool? isMultipart,
  }) {
    return RequestApi(
      id: id ?? this.id,
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      isProcessing: isProcessing ?? this.isProcessing,
      files: files ?? this.files,
      isMultipart: isMultipart ?? this.isMultipart,
    );
  }

  // Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'method': method,
      'headers': headers,
      'body': body,
      'timestamp': timestamp,
      'retryCount': retryCount,
      'isProcessing': isProcessing,
      'files': files?.map((file) => file.toMap()).toList(),
      'isMultipart': isMultipart,
    };
  }

  // Create from map for database retrieval
  factory RequestApi.fromMap(Map<String, dynamic> map) {
    return RequestApi(
      id: map['id'],
      url: map['url'],
      method: map['method'],
      headers: map['headers'],
      body: map['body'],
      timestamp: map['timestamp'],
      retryCount: map['retryCount'],
      isProcessing: map['isProcessing'],
      files: map['files'] != null 
          ? (map['files'] as List).map((f) => RequestFile.fromMap(f)).toList()
          : null,
      isMultipart: map['isMultipart'] ?? false,
    );
  }
}

// New class to handle file information
class RequestFile {
  final String filePath;
  final String fieldName; // Field name for multipart form
  final String fileName;
  final String mimeType;

  RequestFile({
    required this.filePath,
    required this.fieldName,
    required this.fileName,
    required this.mimeType,
  });

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'fieldName': fieldName,
      'fileName': fileName,
      'mimeType': mimeType,
    };
  }

  factory RequestFile.fromMap(Map<String, dynamic> map) {
    return RequestFile(
      filePath: map['filePath'],
      fieldName: map['fieldName'],
      fileName: map['fileName'],
      mimeType: map['mimeType'],
    );
  }

  // Check if file still exists
  Future<bool> exists() async {
    final file = File(filePath);
    return await file.exists();
  }

  // Get file size
  Future<int> getFileSize() async {
    final file = File(filePath);
    return await file.length();
  }
}