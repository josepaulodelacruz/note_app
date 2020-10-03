
import 'package:bloc/bloc.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:uuid/uuid.dart';
import 'package:note_common/models/sub_notes.dart';

class NoteCubit extends Cubit<NoteState> {
  List<NoteModel> notes = [];

  NoteCubit(NoteState state) : super(state);

  void onLoading () {
    emit(LoadingNoteState());
    Future.delayed(Duration(seconds: 2), () {
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
    notes.removeWhere((note) => note.id == id);
    emit(LoadedNoteState(notes));
    emit(DeletedNote('Successfully deleted'));
  }

  void editNote(NoteModel noteModel) {
    final updated = notes.map((note) {
      if(note.id == noteModel.id) {
        return noteModel;
      } else {
        return note;
      }
    }).toList();
    notes = updated;
    emit(LoadedNoteState(notes));
  }


  void addSubNotes (NoteModel noteModel, SubNotes subNotes) {
    int noteIndex;
    notes.map((e) {
      int index = notes.indexOf(e);
      if(noteModel.id == e.id) {
        noteIndex = index;
        return e;
      }
      return e;
    }).toList();
    notes[noteIndex].subNotes.add(subNotes);
    emit(LoadedSubNotesState(notes[noteIndex].subNotes));
    emit(LoadedNoteState(notes));
  }

  void viewSubNotes (List<SubNotes> subNotes) {
    emit(LoadedSubNotesState(subNotes));
  }



}
