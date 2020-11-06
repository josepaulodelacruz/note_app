import 'package:note_common/api/storage_api.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/services/note_services.dart';

class NoteApi extends NoteService {
  NoteModel noteModel;
  StorageApi storageApi = StorageApi();

  @override
  Future<List<NoteModel>> onLoading () async {
    return await storageApi.openStorageBox('notes').then((box) {
      List<dynamic> notes = box.get('notes');
      List<NoteModel> a = notes?.map((note) {
        return NoteModel(
          note.id,
          note.title,
          note.description,
          subNotes: note.subNotes,
        );
      })?.toList() ?? [];
      return a;
    });
  }

  @override
  Future<List<NoteModel>> addNote (List<NoteModel> notes) async {
    storageApi.openStorageBox('notes').then((box) {
      box.put('notes', notes);
    });
  }

  @override
  Future<List<NoteModel>> updateNote (List<NoteModel> notes) async {
    storageApi.openStorageBox('notes').then((box) {
      box.put('notes', notes);
    });
  }

  @override
  void deleteAll () {
    storageApi.openStorageBox('notes').then((box) {
      box.deleteFromDisk();
    });
  }

}
