
class ConnectionTimeout implements Exception {}
class WrongCredemtials implements Exception {}
class InvalidToken implements Exception {} 

class CustomError implements Exception {
  final String message;
  // final bool loggedRequired;
  // final int errorCode;

  CustomError( this.message  );

}