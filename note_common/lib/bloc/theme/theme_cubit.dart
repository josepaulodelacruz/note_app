
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:note_common/bloc/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(ThemeState state) : super(state);

  void changeTheme (theme) {
    emit(Theming(!theme));
  }

}