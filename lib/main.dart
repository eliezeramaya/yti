import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_state.dart';

void main() { runApp(const ProviderScope(child: YTIProApp())); }

class YTIProApp extends ConsumerWidget {
  const YTIProApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'YT Insights Pro',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: mode,
      routerConfig: router,
    );
  }
}
