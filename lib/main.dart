import 'package:flutter/material.dart';
import 'package:turnaround_mobile/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await Environment.initEnvironment();
  // WidgetsFlutterBinding.ensureInitialized();
  // tz.initializeTimeZones(); // Initialize timezone data
  // const ProviderScope(child: MainApp());
  initializeDateFormatting(
    // 'pt_BR', // Change to your desired locale, e.g., 'en_US' for English
    'es_VE', // Change to your desired locale, e.g., 'en_US' for English
    null,
  ).then((_) => runApp(const ProviderScope(child: MainApp())));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final tz.Location caracas = tz.getLocation('America/Caracas');
    // final tz.TZDateTime nowInCaracas = tz.TZDateTime.now(caracas);
    final appRouter = ref.watch(goRouterProvider);
    initializeDateFormatting('es_VE', null);

    // Get the device's local location
    // final tz.Location localLocation = tz.local;
    // final tz.TZDateTime nowInLocalTimezone = tz.TZDateTime.now(localLocation);

    // Example: get a specific timezone

    return MaterialApp.router(
      // builder: (context, child) =>
      //     // This is where you can add any global widgets, like a loading indicator
      //     // or a custom error page.
      //     MediaQuery(
      //       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      //       child: child ?? const SizedBox.shrink(),
      //     ),
      routerConfig: appRouter,
      // theme: AppTheme().getTheme(),
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
