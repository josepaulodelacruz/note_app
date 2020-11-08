
import 'package:hive/hive.dart';

part 'pictures.g.dart';

@HiveType(typeId: 3)
class Photo extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String imagePath;
  @HiveField(2)
  bool isSeleted;

  Photo({this.id, this.imagePath, this.isSeleted = false});

  bool checkIfNull () {
    return [id, imagePath, isSeleted].contains(null);
  }
}
