class AppUpdateState {
  final bool hasUpdate;
  final String? versionName;
  final int? versionCode;
  final String? apkUrl;
  final bool isMandatory;
  final String? releaseNotes;
  final bool isLoading;

  AppUpdateState({
    this.hasUpdate = false,
    this.versionName,
    this.versionCode,
    this.apkUrl,
    this.isMandatory = false,
    this.releaseNotes,
    this.isLoading = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasUpdate': hasUpdate,
      'versionName': versionName,
      'versionCode': versionCode,
      'apkUrl': apkUrl,
      'isMandatory': isMandatory,
      'releaseNotes': releaseNotes,
    };
  }
}