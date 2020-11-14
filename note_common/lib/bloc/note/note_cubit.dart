import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:note_common/api/note_api.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/pictures.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/fixtures/random_quotes.dart';

import 'package:uuid/uuid.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteApi noteApi;
  List<SubNotes> sub = List<SubNotes>();
  List<NoteModel> notes = List<NoteModel>();

  NoteCubit(this.noteApi) : super(null);

  //initialize from memory
  void onLoading() async {
    emit(LoadingNoteState());
    List<NoteModel> _notes = await noteApi.onLoading();
    notes = _notes;
    emit(LoadedNoteState(notes));
  }

  void onloadGridView () async {
    bool isView = await noteApi.onloadListGrid();
    emit(IsView(isView));
  }

  void listGridView (bool isView) async {
    await noteApi.viewListGrid(isView);
    emit(IsView(isView));
  }

  void addNote(String title, String description) async {
    var uuid = Uuid();
    var rnd = Random();
    String desc = description == ""
        ? quotes[rnd.nextInt(quotes.length)].quotes
        : description;
    final note = NoteModel(uuid.v4(), title, desc);
    notes.add(note);
    await noteApi.addNote(notes);
    emit(LoadedNoteState(notes));
  }

  void addSubNotes(NoteModel noteModel, SubNotes subNotes) async {
    int index = notes.indexWhere((element) => element.id == noteModel.id);
    notes[index].subNotes = notes[index].subNotes.toList(growable: true);
    notes[index].subNotes.add(subNotes);
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void deleteNote(String id) async {
    int index = notes.indexWhere((note) => note.id == id);
    notes[index].subNotes = []; // delete subnotes
    notes.removeWhere((note) => note.id == id);
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void editNote(NoteModel noteModel) async {
    var rnd = Random();
    int index = notes.indexWhere((note) => note.id == noteModel.id);
    notes[index].title = noteModel.title;
    notes[index].description = noteModel.description == ""
        ? quotes[rnd.nextInt(quotes.length)].quotes
        : noteModel.description;
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void editSubNotes(NoteModel noteModel, SubNotes subNotes, int index) async {
    int noteIndex = notes.indexWhere((note) => note.id == noteModel.id);
    int index = noteModel.subNotes.indexWhere((sub) => sub.id == subNotes.id);
    notes[noteIndex].subNotes[index] = subNotes;
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void deleteSubNotes(int index, NoteModel noteModel) async {
    int noteIndex = notes.indexWhere((note) => note.id == noteModel.id);
    notes[noteIndex].subNotes.removeAt(index);
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void addImage(String imagePath, String noteId, String subNoteId) async {
    int noteIndex = notes.indexWhere((note) => note.id == noteId);
    int subIndex = notes[noteIndex]
        .subNotes
        .indexWhere((subNotes) => subNotes.id == subNoteId);

    var uuid = Uuid();
    String id = uuid.v4();
    Photo picture = Photo(id: id, imagePath: imagePath);

    notes[noteIndex].coverPhoto = notes[noteIndex].coverPhoto == null
        ? picture.imagePath
        : notes[noteIndex].coverPhoto;

    notes[noteIndex].subNotes[subIndex].photos.add(picture);
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void deleteImage(List<Photo> photos, String noteId, String subNoteId) async {
    int noteIndex = notes.indexWhere((note) => note.id == noteId);
    int subIndex = notes[noteIndex]
        .subNotes
        .indexWhere((subNotes) => subNotes.id == subNoteId);
    notes[noteIndex].subNotes[subIndex].photos = photos;
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void arrangeImage(
    String noteId,
    String subNoteId,
    List<Photo> photos,
  ) async {
    int noteIndex = notes.indexWhere((note) => note.id == noteId);
    int subIndex = notes[noteIndex]
        .subNotes
        .indexWhere((subNotes) => subNotes.id == subNoteId);
    notes[noteIndex].subNotes[subIndex].photos = photos;
    await noteApi.updateNote(notes);
    emit(LoadedNoteState(notes));
  }

  void test() async {
    await noteApi.deleteAll();
  }
}
