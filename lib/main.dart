import 'package:flutter/material.dart';
import 'package:turnaround_mobile/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await Environment.initEnvironment();
  initializeDateFormatting(
    'pt_BR', // Change to your desired locale, e.g., 'en_US' for English
    null,
  ).then((_) => runApp(const ProviderScope(child: MainApp())));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);
    // initializeDateFormatting('pt_BR', null);

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
