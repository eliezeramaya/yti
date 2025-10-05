import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends Notifier<ThemeMode> {
	static const _kKey = 'theme_mode';

	@override
	ThemeMode build() {
		// default
		_load();
		return ThemeMode.dark;
	}

	Future<void> _load() async {
		final prefs = await SharedPreferences.getInstance();
		final v = prefs.getString(_kKey);
		if (v == null) return;
		final mode = switch (v) {
			'light' => ThemeMode.light,
			'dark' => ThemeMode.dark,
			'system' => ThemeMode.system,
			_ => ThemeMode.dark,
		};
		if (state != mode) state = mode;
	}

	Future<void> setMode(ThemeMode mode) async {
		state = mode;
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_kKey, switch (mode) {
			ThemeMode.light => 'light',
			ThemeMode.dark => 'dark',
			ThemeMode.system => 'system',
		});
	}

	Future<void> toggle() async {
		final isLight = state == ThemeMode.light;
		await setMode(isLight ? ThemeMode.dark : ThemeMode.light);
	}
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
final themeModeProvider = themeControllerProvider; // alias for existing reads
