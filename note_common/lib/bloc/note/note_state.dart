
import 'package:flutter/foundation.dart';
import 'package:note_common/models/note_model.dart';

@immutable
abstract class NoteState {}

class InitialState extends NoteState {}

class LoadingNoteState extends NoteState {}

class LoadedNoteState extends NoteState {
  final List<NoteModel> notes;

  LoadedNoteState(this.notes);

  List<Object> get props => [notes];
}

class ErrorState extends NoteState {
  final String message;

  ErrorState(this.message);

  List<Object> get props => [message];

  @override
  String toString() {
    return message;
  }
}

class DeletedNote extends NoteState {
  final String message;

  DeletedNote(this.message);

  List<Object> get props => [message];
}

