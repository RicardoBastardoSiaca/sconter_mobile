import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamController<bool> connectionChangeController = StreamController<bool>.broadcast();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      await _checkInternetConnection();
    });
    // Initial check
    _checkInternetConnection();
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  Future<void> _checkInternetConnection() async {
    bool isConnected = await InternetConnection().hasInternetAccess;
    connectionChangeController.add(isConnected);
  }

  Future<bool> get hasConnection => InternetConnection().hasInternetAccess;

  void dispose() {
    connectionChangeController.close();
  }
}