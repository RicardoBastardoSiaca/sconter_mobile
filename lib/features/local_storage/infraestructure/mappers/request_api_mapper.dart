

import '../../domain/domain.dart';

class RequestApiMapper {

  static List<RequestApi> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
  static RequestApi fromJson(Map<String, dynamic> json) {
    final ts = json['timestamp'];
    DateTime timestampValue;
    if (ts is int) {
      timestampValue = DateTime.fromMillisecondsSinceEpoch(ts);
    } else if (ts is String) {
      timestampValue = DateTime.tryParse(ts) ?? DateTime.fromMillisecondsSinceEpoch(0);
    } else if (ts is DateTime) {
      timestampValue = ts;
    } else {
      timestampValue = DateTime.fromMillisecondsSinceEpoch(0);
    }

    return RequestApi(
      id: json['id'],
      url: json['url'],
      method: json['method'],
      body: json['body'],
      headers: json['headers'] != null ? Map<String, String>.from(json['headers']) : null,
      timestamp: timestampValue.millisecondsSinceEpoch,
      retryCount: json['retryCount'] ?? 0,
      isProcessing: json['isProcessing'] ?? false,
    );
  }
}
