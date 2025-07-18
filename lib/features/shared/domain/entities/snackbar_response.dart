class SnackbarResponse {
  final String message;
  final bool success;

  SnackbarResponse({required this.message, this.success = false});

  @override
  String toString() {
    return 'SnackbarResponse(message: $message, success: $success)';
  }
}

//   // Factory method to create a success response
//   factory SnackbarResponse.success(String message) {
//     return SnackbarResponse(message: message, success: true);
//   }

//   // Factory method to create an error response
//   factory SnackbarResponse.error(String message) {
//     return SnackbarResponse(message: message, success: false);
//   }
// }
