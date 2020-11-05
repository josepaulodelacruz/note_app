import 'package:camera/camera.dart';
import 'package:note_common/models/pictures.dart';

class ScreenArguments {
  int index;
  String noteId;
  CameraDescription firstCamera;
  String subNoteId;
  List<Photo> photos;

  ScreenArguments({
    this.noteId,
    this.firstCamera,
    this.subNoteId,
    this.photos,
    this.index
  });

}
