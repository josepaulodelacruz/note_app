import 'package:note_common/models/theme.dart';

abstract class ThemeServices {

  Future<Theme> loadTheme();

  Future<Theme> changeTheme(bool theme);

}
