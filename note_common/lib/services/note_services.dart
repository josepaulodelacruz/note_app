
import 'package:note_common/models/note_model.dart';

abstract class NoteService {
  Future<List<NoteModel>> onLoading();

  Future<List<NoteModel>> addNote(List<NoteModel> noteModel);

  Future<List<NoteModel>> updateNote (List<NoteModel> noteModel);

  void deleteAll ();
}
