import 'package:flutter/foundation.dart';

@immutable
abstract class ThemeState {}

class Theming extends ThemeState {
  final bool enableTheme;

  Theming(this.enableTheme);
}