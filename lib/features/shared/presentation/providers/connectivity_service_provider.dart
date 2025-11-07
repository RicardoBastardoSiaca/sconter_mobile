// providers/connectivity_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart';

import '../../../auth/presentation/providers/providers.dart';
import '../../../local_storage/local_storage.dart';
import '../../shared.dart';

// Provider for the connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();

  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

// Provider localStorageRepositoryProvider
final _localStorageRepositoryProvider = Provider((ref) {
  return RequestApiRepositoryImpl(dataSource: DriftRequestApiDatasource());
});

// StateNotifierProvider for connectivity state and business logic
final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, AsyncValue<bool>>((ref) {
      final connectivityService = ref.watch(connectivityServiceProvider);
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);
      final accessToken = ref.watch( authProvider ).loginResponse?.token ?? '';

      final RequestProcessor _requestManager = RequestProcessor( accessToken: accessToken );

      return ConnectivityNotifier(connectivityService, localStorageRepository, accessToken, _requestManager);
    });

// Notifier class that handles connectivity state and reactions
class ConnectivityNotifier extends StateNotifier<AsyncValue<bool>> {
  final ConnectivityService _connectivityService;
  final RequestApiRepositoryImpl localStorageRepository;
  final String accessToken;
  final RequestProcessor _requestManager;

  ConnectivityNotifier(this._connectivityService, this.localStorageRepository, this.accessToken, this._requestManager)
    : super(const AsyncValue.loading()) {
    // Set initial value
    state = AsyncValue.data(_connectivityService.hasInternet.value);

    // Listen to connectivity changes
    _connectivityService.hasInternet.addListener(_onConnectivityChanged);
  }

  void _onConnectivityChanged() {
    final newStatus = _connectivityService.hasInternet.value;
    final oldStatus = state.valueOrNull ?? false;

    // Update state
    state = AsyncValue.data(newStatus);

    // Trigger actions based on connectivity changes
    if (oldStatus == false && newStatus == true) {
      _onInternetRestored();
    } else if (oldStatus == true && newStatus == false) {
      _onInternetLost();
    }
  }

  // final ConnectivityService _connectivityService = ConnectivityService();
  void _onInternetRestored  () {
    // Perform actions when internet is restored
    print('Internet restored - performing sync operations');

    // if there is request apis in the list to sync, perform the sync here
    // from localStorageRepositoryProvider
    // final localStorageRepository = _ref.read(_localStorageRepositoryProvider);
    // You can implement your sync logic here
    print('Syncing stored API requests...');
    // final accessToken = ref.watch( authProvider ).loginResponse?.token ?? '';
    try {
    localStorageRepository.getAllRequestApis().then((requests) async {
        await _requestManager.processAllRequests(requests, localStorageRepository);
      print('Found ${requests.length} requests to sync.');
      
      // for (var request in requests) {
      //   // deleting all requests after processing
      //   await localStorageRepository.deleteApiRequestApi(request.id);
      // }
      //   // Perform API call based on stored request
      //   // After successful call, delete the request from local storage
      //   print('Syncing request: ${request}');

      //   // TODO: Implement actual API call logic here



      //   // accessToken
        
      //   // After syncing, delete the request
      //   // localStorageRepository.deleteApiRequestApi(request.id);
      // }
    });

    } catch (e) {
      print('Error processing pending requests: $e');
    }
  // }
    // });

    // Example actions you can trigger:
    // - Sync local data with server
    // - Retry failed API calls
    // - Refresh data from network
    // - Update other providers that depend on connectivity

    // You can also use Riverpod to trigger other providers:
    // ref.read(syncProvider.notifier).syncData();
    // ref.read(dataProvider.notifier).refresh();
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

// Helper provider for simple connectivity state (without AsyncValue)
final isConnectedProvider = Provider<bool>((ref) {
  final connectivityState = ref.watch(connectivityProvider);
  return connectivityState.valueOrNull ?? false;
});
