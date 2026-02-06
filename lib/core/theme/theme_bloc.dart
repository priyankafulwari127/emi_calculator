import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class AppThemeState {
  final ThemeMode themeMode;
  AppThemeState(this.themeMode);
}

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeState(ThemeMode.system));

  void setThemeSystem () => emit(AppThemeState(ThemeMode.system));
  void setThemeLight () => emit(AppThemeState(ThemeMode.light));
  void setThemeDark () => emit(AppThemeState(ThemeMode.dark));
}
