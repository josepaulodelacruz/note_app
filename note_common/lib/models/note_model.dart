
import 'package:hive/hive.dart';
import 'package:note_common/models/sub_notes.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class NoteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<SubNotes> subNotes = List<SubNotes>();

  @HiveField(4)
  String coverPhoto;

  NoteModel(
    this.id,
    this.title,
    this.description,
    {this.subNotes = const [], this.coverPhoto}
  );


  Map<String, dynamic> toMap () {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'coverPhoto': this.coverPhoto,
      'subNotes': this.subNotes,
    };
  }


  bool checkIfNull () {
    return [id, title, description, coverPhoto, subNotes].contains(null);
  }

}
