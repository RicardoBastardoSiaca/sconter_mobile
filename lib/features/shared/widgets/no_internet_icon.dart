import 'package:flutter/material.dart';

import '../shared.dart';


class NoInternetIcon extends StatefulWidget {
  const NoInternetIcon({super.key});
  

  @override
  State<NoInternetIcon> createState() => _NoInternetIconState();
}

class _NoInternetIconState extends State<NoInternetIcon> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    _connectivityService.connectionChange.listen((isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
    });
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // final ConnectivityService _connectivityService = ConnectivityService();
    return 
      !_isConnected
        ? const Icon(
            Icons.wifi_off,
            // Icons.signal_wifi_off,
            color: Colors.red,
            size: 22.0,
          )
        : const SizedBox.shrink();
  }
}