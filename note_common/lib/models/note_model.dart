
import 'package:note_common/models/sub_notes.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final List<SubNotes> subNotes;

  NoteModel(this.id, this.title, this.description, {this.subNotes = const []});
}