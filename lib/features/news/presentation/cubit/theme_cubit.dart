import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box themeBox;

  ThemeCubit({required this.themeBox})
      : super(_getInitialTheme(themeBox));

  static ThemeMode _getInitialTheme(Box box) {
    final bool? isDark = box.get(AppConstants.isDarkModeKey);
    if (isDark == null) return ThemeMode.system;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final isCurrentlyDark = state == ThemeMode.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    themeBox.put(AppConstants.isDarkModeKey, !isCurrentlyDark);
    emit(newMode);
  }
}
