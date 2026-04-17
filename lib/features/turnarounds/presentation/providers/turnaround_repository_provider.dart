


// poder establecer  en toda la aplicacion la intancia de TurnaroundRepositoryImpl


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/auth/presentation/providers/auth_provider.dart';

import '../../domain/domain.dart';
import '../../insfrastructure/infrastructure.dart';

final turnaroundRepositoryProvider = Provider<TurnaroundsRepository>((ref) {

  final accessToken = ref.watch( authProvider ).loginResponse?.token ?? '';
  
  final turnaroundsRepository = TurnaroundsRepositoryImpl( TurnaroundsDatasourceImpl(accessToken: accessToken) );
  
  return turnaroundsRepository;

});