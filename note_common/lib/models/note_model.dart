
import 'package:note_common/models/sub_notes.dart';

class NoteModel {
  String id;
  String title;
  String description;
  List<SubNotes> subNotes = List<SubNotes>();

  NoteModel(this.id, this.title, this.description, {this.subNotes});
}