// providers/connectivity_provider.dart
import 'package:flutter/foundation.dart';
import '../../shared.dart';

class ConnectivityProvider with ChangeNotifier {
  final ConnectivityService _connectivityService;
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  
  ConnectivityProvider(this._connectivityService) {
    _connectivityService.hasInternet.addListener(_onConnectivityChanged);
    _isConnected = _connectivityService.hasInternet.value;
  }
  
  void _onConnectivityChanged() {
    final newStatus = _connectivityService.hasInternet.value;
    
    if (_isConnected != newStatus) {
      _isConnected = newStatus;
      
      if (_isConnected) {
        _onInternetRestored();
      } else {
        _onInternetLost();
      }
      
      notifyListeners();
    }
  }
  
  void _onInternetRestored() {
    // Perform actions when internet is restored
    print('Internet restored - performing sync operations');
    
    // Example actions:
    // - Sync local data with server
    // - Retry failed API calls
    // - Refresh data from network
    // - Update online/offline status in UI
  }
  
  void _onInternetLost() {
    // Perform actions when internet is lost
    print('Internet lost - switching to offline mode');
    
    // Example actions:
    // - Show offline banner
    // - Cache operations
    // - Disable network-dependent features
  }
  
  @override
  void dispose() {
    _connectivityService.hasInternet.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}