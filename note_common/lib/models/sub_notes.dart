import 'package:hive/hive.dart';
import 'package:note_common/models/pictures.dart';

part 'sub_notes.g.dart';

@HiveType(typeId: 2)
class SubNotes extends HiveObject {

  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime isDate;
  @HiveField(2)
  String title;
  @HiveField(3)
  String subTitle;
  @HiveField(4)
  List<Photo> photos = List<Photo>();

  SubNotes(
    this.id,
    this.isDate,
    this.title,
    this.subTitle,
    {this.photos}
  );

}
