class SimpleApiResponse {
  final String message;
  final bool success;
  final String? error;
  final List<String>? errorList;
  final String? status;
  final int? statusCode;

  SimpleApiResponse({
    required this.message,
    required this.success,
    this.error,
    this.errorList,
    this.status,
    this.statusCode,
  });
}
