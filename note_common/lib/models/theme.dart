

import 'package:hive/hive.dart';

part 'theme.g.dart';

@HiveType(typeId: 0)
class Theme extends HiveObject {

  @HiveField(0)
  bool theme;

  Theme();
}