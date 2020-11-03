
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:note_common/api/change_theme_api.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_common/models/theme.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ChangeThemeApi changeThemeApi = ChangeThemeApi();
  ThemeCubit(ThemeState state, this.changeThemeApi) : super(state);

  Future<bool> loadTheme () async {
    Theme isEnable = await changeThemeApi.loadTheme();
    emit(Theming(isEnable.theme));
    return isEnable.theme;
  }

  void changeTheme (theme) async {
    Theme isEnable = await changeThemeApi.changeTheme(theme);
    print('Themeing ${isEnable.theme}');
    emit(Theming(isEnable.theme));
  }

}