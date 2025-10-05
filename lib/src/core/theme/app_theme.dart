import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bgStart = Color(0xFF0D0D0F);
  static const bgEnd   = Color(0xFF111114);
  static const surface = Color.fromRGBO(255,255,255,0.04);
  static const surfaceStrong = Color.fromRGBO(255,255,255,0.06);
  static const border  = Color.fromRGBO(255,255,255,0.08);
  static const text    = Color(0xFFF9FAFB);
  static const textMuted = Color(0xFF9CA3AF);
  static const accent  = Color(0xFF3B82F6);
  static const accentDark = Color(0xFF1E40AF);
  static const success = Color(0xFF10B981);
  static const error   = Color(0xFFEF4444);
}

ThemeData buildTheme(Brightness mode) {
  final isLight = mode == Brightness.light;
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: mode,
      primary: AppColors.accent,
      secondary: AppColors.accentDark,
    ),
    textTheme: GoogleFonts.interTextTheme(),
  );
  return base.copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: isLight ? Colors.black : AppColors.text,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: isLight ? Colors.black : AppColors.text,
      ),
    ),
    cardTheme: CardThemeData(
      color: isLight ? Colors.white : AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isLight ? Colors.black12 : AppColors.border),
      ),
    ),
  );
}

class ThemeGradientBackground extends StatelessWidget {
  final Widget child;
  final bool isLight;
  const ThemeGradientBackground({super.key, required this.child, required this.isLight});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: isLight ? const [Color(0xFFF8FAFC), Color(0xFFEEF2F7)]
                          : const [AppColors.bgStart, AppColors.bgEnd],
        ),
      ),
      child: child,
    );
  }
}
