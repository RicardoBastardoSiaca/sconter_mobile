import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scounter_mobile/config/config.dart';
import 'package:scounter_mobile/features/shared/domain/domain.dart';

// import 'package:turnaround_mobile/config/config.dart';
// import 'package:turnaround_mobile/features/shared/domain/domain.dart';

final appUpdateProvider = StateNotifierProvider<AppUpdateNotifier, AppUpdateState>((ref) {
  return AppUpdateNotifier();
});

class AppUpdateNotifier extends StateNotifier<AppUpdateState> {
  AppUpdateNotifier() : super(AppUpdateState());

  final Dio _dio = Dio();
  // Cambia a la IP o dominio de tu servidor
  // static const String apiUrl = 'http://192.168.1.50:8000/apk-version/latest/';
 static String apiUrl = '${Environment.apiUrl}/apk-version/latest/';
  Future<void> checkForUpdate() async {
    state = AppUpdateState(isLoading: true);

    try {
      WidgetsFlutterBinding.ensureInitialized();
      final packageInfo = await PackageInfo.fromPlatform();
      final localBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final int serverBuildNumber = data['version_code'] ?? 0;

        if (serverBuildNumber > localBuildNumber) {
          state = AppUpdateState(
            hasUpdate: true,
            versionName: data['version_name'],
            versionCode: serverBuildNumber,
            apkUrl: data['apk_url'],
            isMandatory: data['is_mandatory'] ?? false,
            releaseNotes: data['release_notes'],
            isLoading: false,
          );
          return;
        }
      }
    } catch (e) {
      print('Error al verificar actualización en Riverpod: $e');
    }

    state = AppUpdateState(hasUpdate: false, isLoading: false);
  }
}