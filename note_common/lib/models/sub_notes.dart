import 'package:note_common/models/pictures.dart';

class SubNotes {
  String id;
  DateTime isDate;
  String title;
  String subTitle;
  List<Pictures> photos = List<Pictures>();

  SubNotes(
    this.id,
    this.isDate,
    this.title,
    this.subTitle,
    {this.photos}
  );

}