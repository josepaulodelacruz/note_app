import 'package:bloc/bloc.dart';
import 'package:note_common/api/note_api.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/pictures.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_common/services/note_services.dart';

import 'package:uuid/uuid.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteApi noteApi;
  List<SubNotes> sub = List<SubNotes>();
  List<NoteModel> notes = List<NoteModel>();

  NoteCubit(this.noteApi) : super(null);

  void onLoading () async {
    emit(LoadingNoteState());
    Future.delayed(Duration(seconds: 2), () async {
      await noteApi.onLoading().then((res) {
        print('list: ${res}');
      });
      emit(LoadedNoteState(notes));
    });
  }

  void addNote (String title, String description) {
    var uuid = Uuid();
    final note = NoteModel(uuid.v4(), title, description);
    notes.add(note);
    emit(LoadedNoteState(notes));
  }

  void deleteNote(String id) {
    int index = notes.indexWhere((note) => note.id == id);
    notes[index].subNotes = []; // delete subnotes
    notes.removeWhere((note) => note.id == id);
    emit(LoadedNoteState(notes));
  }

  void editNote(NoteModel noteModel) {
    final updated = notes.map((note) {
      return note.id == noteModel.id ?
        noteModel : note;
    }).toList();
    notes = updated;
    emit(LoadedNoteState(notes));
  }

  void addSubNotes (NoteModel noteModel, SubNotes subNotes) {
    sub.add(subNotes);
    int index = notes.indexWhere((element) => element.id == noteModel.id);
    notes[index].subNotes = sub;
    emit(LoadedNoteState(notes));
  }

  void editSubNotes (NoteModel noteModel, SubNotes subNotes, int index) {
    int noteIndex = notes.indexWhere((note) => note.id == noteModel.id);
    int index = noteModel.subNotes.indexWhere((sub) => sub.id == subNotes.id);
    notes[noteIndex].subNotes[index] = subNotes;
    emit(LoadedNoteState(notes));
  }

  void deleteSubNotes (int index, NoteModel noteModel) {
    int noteIndex = notes.indexWhere((note) => note.id == noteModel.id);
    notes[noteIndex].subNotes.removeAt(index);
    emit(LoadedNoteState(notes));
  }

  void addImage (String imagePath, String noteId, String subNoteId) {
    int noteIndex = notes.indexWhere((note) => note.id == noteId);
    int subIndex = notes[noteIndex].subNotes.indexWhere((subNotes) => subNotes.id == subNoteId);
    var uuid = Uuid();
    String id = uuid.v4();
    Pictures picture = Pictures(id: id, imagePath: imagePath);
    notes[noteIndex].subNotes[subIndex].photos.add(picture);
    emit(LoadedNoteState(notes));
  }

  void deleteImage (List<Pictures> photos, String noteId, String subNoteId) {
    int noteIndex = notes.indexWhere((note) => note.id == noteId);
    int subIndex = notes[noteIndex].subNotes.indexWhere((subNotes) => subNotes.id == subNoteId);
    notes[noteIndex].subNotes[subIndex].photos = photos;
    emit(LoadedNoteState(notes));
  }

  void test() async {
    String title = 'testing';
    String description = 'Testing description';
    var uuid = Uuid();
    final note = NoteModel(uuid.v4(), title, description);
    notes.add(note);
    await noteApi.addNote(notes);
  }

}
