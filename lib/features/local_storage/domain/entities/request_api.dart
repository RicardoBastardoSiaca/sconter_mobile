


class RequestApi {
  final int id;
  final String url;
  final String method; // 'GET', 'POST', 'PUT', 'DELETE', 'PATCH'
  final Map<String, dynamic>? headers;
  final dynamic body; // Can be any serializable data
  final int timestamp;
  final int retryCount;
  final bool isProcessing;

  RequestApi({
    required this.id,
    required this.url,
    required this.method,
    this.headers,
    this.body,
    required this.timestamp,
    this.retryCount = 0,
    this.isProcessing = false,
    // 
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'method': method,
      'headers': headers,
      'body': body,
      'timestamp': timestamp,
      'retryCount': retryCount,
      'isProcessing': isProcessing,
    };
  }

  factory RequestApi.fromJson(Map<String, dynamic> json) {
    return RequestApi(
      id: json['id'],
      url: json['url'],
      method: json['method'],
      headers: Map<String, dynamic>.from(json['headers'] ?? {}),
      body: json['body'],
      timestamp: json['timestamp'],
      retryCount: json['retryCount'] ?? 0,
      isProcessing: json['isProcessing'] ?? false,
    );
  }

// RequestApiEntity toEntity() {
//     return RequestApiEntity(
//       id: id,
//       url: url,
//       method: method,
//       headers: headers != null ? json.encode(headers) : null,
//       body: body != null ? json.encode(body) : null,
//       timestamp: timestamp,
//       retryCount: retryCount,
//     );
//   }

  // static RequestApi fromEntity(RequestApiEntity entity) {
  //   return RequestApi(
  //     id: entity.id,
  //     url: entity.url,
  //     method: entity.method,
  //     headers: entity.headers != null ? json.decode(entity.headers!) : null,
  //     body: entity.body != null ? json.decode(entity.body!) : null,
  //     timestamp: entity.timestamp,
  //     retryCount: entity.retryCount,
  //   );
  // }
}


