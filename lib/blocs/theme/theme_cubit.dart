import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:checklist_to_do/repositories/settings/settings.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required SettingsRepositoryInterface settingsRepositoryInterface})
      : _settingsRepository = settingsRepositoryInterface,
        super(const ThemeState(Brightness.light)) {
    _checkSelectedTheme();
  }

  final SettingsRepositoryInterface _settingsRepository;

  Future<void> setThemeBrightness(Brightness brightness) async {
    emit(ThemeState(brightness));
    await _settingsRepository
        .setDarkThemeSelected(brightness == Brightness.dark);
  }

  void _checkSelectedTheme() {
    try {
      final brightness = _settingsRepository.isDarkThemeSelected()
          ? Brightness.dark
          : Brightness.light;
      emit(ThemeState(brightness));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
