import 'package:note_common/api/storage_api.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/services/note_services.dart';

class NoteApi extends NoteService {
  NoteModel noteModel;
  StorageApi storageApi = StorageApi();

  @override
  Future<List<NoteModel>> onLoading () async {
    return await storageApi.openStorageBox('notes').then((box) {
      return box.get('notes');
    });
  }


  @override
  void test(String a) {
    // TODO: implement test
    print(a);
    print('DEEP NOTE API CALLED');
  }

  @override
  Future<List<NoteModel>> addNote (List<NoteModel> noteModel) async {
    storageApi.openStorageBox('notes').then((box) {
      box.put('notes', noteModel);
    });
  }

}
