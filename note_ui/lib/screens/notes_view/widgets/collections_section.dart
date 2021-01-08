import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/screens/notes_view/widgets/album_slider.dart';
import 'package:note_ui/screens/notes_view/widgets/upper_header.dart';
import 'package:note_ui/screens/notes_view/widgets/upper_subtitle.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class CollectionsSection extends StatelessWidget {
  NoteModel noteModel;
  SubNotes subNotes;
  TextEditingController newTitle;
  TextEditingController newDescription;
  bool isView;
  DateTime selectedDate = DateTime.now();
  final Function expand;
  final Function isSetState;
  final Function renderBottomModal;


  CollectionsSection({
    this.noteModel,
    this.newTitle,
    this.newDescription,
    this.isView,
    this.subNotes,
    this.expand,
    this.isSetState,
    this.renderBottomModal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UpperHeader(
            noteModel: noteModel,
            subNotes: subNotes),
          UpperSubtitle(
            noteModel: noteModel,
            newTitle: newTitle,
            newDescription:  newDescription),
          AlbumSlider(
            noteModel: noteModel,
            isView: isView,
            renderBottomModal: () { renderBottomModal(); },
            isSetState: (note) => isSetState(note),
            expand: (view) => expand(view)),
        ],
      ),
    );
  }
}