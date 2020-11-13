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
          coverPhoto: note.coverPhoto,
        );
      })?.toList() ?? [];
      return a;
    });
  }

  @override
  Future<bool> onloadListGrid () async {
    return await storageApi.openStorageBox('grid-list').then((box) {
      return box.get('grid-list', defaultValue: false);
    });
  }

  @override
  Future viewListGrid(bool isView) async {
    await storageApi.openStorageBox('grid-list').then((box) {
      box.put('grid-list', isView);
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
