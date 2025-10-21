

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../local_storage.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return RequestApiRepositoryImpl(
    dataSource: DriftRequestApiDatasource(),
  );
});