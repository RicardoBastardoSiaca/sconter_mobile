class SimpleApiResponse {
  final String message;
  final bool success;
  final String? error;
  final String? status;

  SimpleApiResponse({
    required this.message,
    required this.success,
    this.error,
    this.status,
  });
}
