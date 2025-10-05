import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../theme/theme_state.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/analyze/analyze_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const RootScaffold(child: DashboardScreen())),
      GoRoute(path: '/analyze', builder: (_, __) => const RootScaffold(child: AnalyzeScreen())),
    ],
  );
});

class RootScaffold extends ConsumerWidget {
  final Widget child;
  const RootScaffold({super.key, required this.child});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isLight = mode == ThemeMode.light;
    return ThemeGradientBackground(
      isLight: isLight,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('YT Insights Pro'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(themeModeProvider.notifier).state =
                  isLight ? ThemeMode.dark : ThemeMode.light;
              },
              child: Text(isLight ? 'Oscuro' : 'Claro',
                style: TextStyle(color: isLight ? Colors.black : AppColors.text)),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Row(
          children: [
            Container(
              width: 240, margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32, width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentDark]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _NavBtn(label: 'Dashboard', onTap: ()=> context.go('/')),
                  _NavBtn(label: 'Analizar Video', onTap: ()=> context.go('/analyze')),
                ],
              ),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.only(right:16, top:16, bottom:16),
              child: child,
            ))
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const _NavBtn({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceStrong,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
