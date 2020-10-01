
import 'package:bloc/bloc.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:uuid/uuid.dart';

class NoteCubit extends Cubit<NoteState> {
  List<NoteModel> _notes = [];

  NoteCubit(NoteState state) : super(state);

  void onLoading () {
    emit(LoadingNoteState());
    Future.delayed(Duration(seconds: 2), () {
      emit(LoadedNoteState(_notes));
    });
  }

  void addNote (String title, String description) {
    var uuid = Uuid();
    final note = NoteModel(uuid.v4(), title, description);
    _notes.add(note);
    emit(LoadedNoteState(_notes));
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    emit(LoadedNoteState(_notes));
    emit(DeletedNote('Successfully deleted'));
  }



}