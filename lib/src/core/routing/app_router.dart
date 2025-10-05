import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
          leading: const Icon(LucideIcons.barChart3, size: 20),
          title: const Text('YT Insights Pro'),
          actions: [
            PopupMenuButton<ThemeMode>(
              tooltip: 'Tema',
              icon: Icon(
                switch (mode) {
                  ThemeMode.light => LucideIcons.sun,
                  ThemeMode.dark => LucideIcons.moon,
                  ThemeMode.system => LucideIcons.monitor,
                },
                color: isLight ? Colors.black : AppColors.text,
              ),
              onSelected: (m) => ref.read(themeModeProvider.notifier).setMode(m),
              itemBuilder: (_) => [
                PopupMenuItem(value: ThemeMode.light, child: Row(children: const [Icon(LucideIcons.sun, size: 16), SizedBox(width: 8), Text('Claro')]))
                ,PopupMenuItem(value: ThemeMode.dark, child: Row(children: const [Icon(LucideIcons.moon, size: 16), SizedBox(width: 8), Text('Oscuro')]))
                ,PopupMenuItem(value: ThemeMode.system, child: Row(children: const [Icon(LucideIcons.monitor, size: 16), SizedBox(width: 8), Text('Sistema')]))
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Row(
          children: [
            Container(
              width: 240, margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLight ? Colors.white : AppColors.surface,
                border: Border.all(color: isLight ? Colors.black12 : AppColors.border),
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
                  Text('Tema', style: TextStyle(color: isLight ? Colors.black54 : AppColors.textMuted, fontSize: 12)),
                  const SizedBox(height: 4),
                  _ThemeSelector(mode: mode),
                  const SizedBox(height: 12),
                  _NavBtn(
                    label: 'Dashboard',
                    icon: LucideIcons.layoutDashboard,
                    onTap: ()=> context.go('/'),
                  ),
                  _NavBtn(
                    label: 'Analizar Video',
                    icon: LucideIcons.lineChart,
                    onTap: ()=> context.go('/analyze'),
                  ),
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
  final String label; final VoidCallback onTap; final IconData? icon;
  const _NavBtn({required this.label, required this.onTap, this.icon});
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isLight ? const Color.fromRGBO(0,0,0,0.04) : AppColors.surfaceStrong,
            border: Border.all(color: isLight ? Colors.black12 : AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
          ]),
        ),
      ),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  final ThemeMode mode;
  const _ThemeSelector({required this.mode});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    Widget btn(ThemeMode m, String label, IconData icon) {
      final selected = mode == m;
      return Expanded(
        child: InkWell(
          onTap: () => ref.read(themeModeProvider.notifier).setMode(m),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
        color: selected
          ? (isLight ? AppColors.accent.withValues(alpha: 0.12) : AppColors.surfaceStrong)
                  : (isLight ? const Color.fromRGBO(0,0,0,0.04) : AppColors.surfaceStrong),
              border: Border.all(color: isLight ? Colors.black12 : AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 16), const SizedBox(width: 6), Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ]),
          ),
        ),
      );
    }

    return Row(children: [
      btn(ThemeMode.light, 'Claro', LucideIcons.sun), const SizedBox(width: 6),
      btn(ThemeMode.dark, 'Oscuro', LucideIcons.moon), const SizedBox(width: 6),
      btn(ThemeMode.system, 'Sistema', LucideIcons.monitor),
    ]);
  }
}
