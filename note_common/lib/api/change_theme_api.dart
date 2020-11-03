
import 'package:note_common/api/storage_api.dart';
import 'package:note_common/models/theme.dart';
import 'package:note_common/services/theme_services.dart';

class ChangeThemeApi extends ThemeServices {
  StorageApi storageApi = StorageApi();

  @override
  Future<Theme> loadTheme() async {
    return await storageApi.openStorageBox('theme-box').then((box) {
      Theme boxTheme = box.get('theme');
      print('initial Theme: ${boxTheme.theme}');
      return boxTheme;
    });
  }

  @override
  Future<Theme> changeTheme (bool isTheme) async {
    return await storageApi.openStorageBox('theme-box').then((box) {
      var theme = Theme()
          ..theme = !isTheme;
      box.put('theme', theme);
      theme.save();
      Theme boxTheme = box.get('theme');
      return boxTheme;
    });
  }



}