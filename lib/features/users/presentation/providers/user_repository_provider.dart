


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/providers.dart';
import '../../domain/repositories/user_repository.dart';
import '../../infrastructure/datasources/user_datasource_impl.dart';
import '../../infrastructure/repositories/user_repository_impl.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {

   final accessToken = ref.watch( authProvider ).loginResponse?.token ?? '';

   final userRepository = UserRepositoryImpl( UserDatasourceImpl(accessToken: accessToken) );
  // Return an instance of UserRepository
  return userRepository;
});