
import 'package:note_common/models/note_model.dart';

abstract class NoteService {
  void test(String a);

  Future<List<NoteModel>> onLoading();

  Future<List<NoteModel>> addNote(List<NoteModel> noteModel);
}
