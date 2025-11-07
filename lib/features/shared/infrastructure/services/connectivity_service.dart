import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamController<bool> connectionChangeController = StreamController<bool>.broadcast();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      await _checkInternetConnection();
      print('******* Connectivity changed: $results current internet status $hasConnection *********' );
    });
    // Initial check
    _checkInternetConnection();
    _init();
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  Future<void> _checkInternetConnection() async {
    bool isConnected = await InternetConnection().hasInternetAccess;
    connectionChangeController.add(isConnected);
  }

  Future<bool> get hasConnection => InternetConnection().hasInternetAccess;

  void dispose() {
    // TODO: AQUI se cierra 
    connectionChangeController.close();
    _hasInternet.dispose();
  }



  // *******************************************************************************************
   final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> _hasInternet = ValueNotifier<bool>(false);
  
  ValueNotifier<bool> get hasInternet => _hasInternet;

   Future<void> _init() async {
    // Check initial status
    await _checkConnection();
    
    // Listen for changes
    _connectivity.onConnectivityChanged.listen((result) {
      _checkConnection();

      print('Connectivity changed: $result. Current internet status: ${_hasInternet.value}');
    });
  }
  
  Future<void> _checkConnection() async {
    try {
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      // final hasConnection = _isConnected(result[0]);
      final hasConnection = _isConnected(result[0]);
      if (_hasInternet.value != hasConnection) {
        _hasInternet.value = hasConnection;
      }
    } catch (e) {
      _hasInternet.value = false;
    }
  }
  
  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }


}