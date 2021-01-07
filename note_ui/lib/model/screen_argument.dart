import 'package:camera/camera.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/pictures.dart';
import 'package:note_common/models/sub_notes.dart';

class ScreenArguments {
  int index;
  String noteId;
  CameraDescription firstCamera;
  String subNoteId;
  List<Photo> photos;
  SubNotes subNotes;
  NoteModel noteModel;

  ScreenArguments({
    this.noteId,
    this.firstCamera,
    this.subNoteId,
    this.photos,
    this.index,
    this.subNotes,
    this.noteModel,
  });

}
