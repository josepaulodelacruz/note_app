import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class AlbumSlider extends StatelessWidget {
  NoteModel noteModel;
  Function isSetState;

  AlbumSlider({this.noteModel, this.isSetState});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Collections', style: Theme.of(context).textTheme.subtitle1),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Divider(thickness: 2),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.only(left: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              children: noteModel.subNotes?.map((note) {
                int index = noteModel.subNotes.indexOf(note);
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[500],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: InkWell(
                    onTap: () => isSetState(note),
                    child: Card(
                      child: Stack(
                        children: [
                          if(note.photos.length > 0) ...[
                            Align(
                              alignment: Alignment.center,
                              child: Image.file(File(note.photos[0].imagePath), fit: BoxFit.cover, width: 150),
                            ),
                          ],
                          Align(
                            alignment: Alignment.center,
                            child: PopupMenuButton(
                              icon: Icon(Icons.add_box),
                              onSelected: (value) {
                                switch(value) {
                                  case 'view':
                                    Navigator
                                        .pushNamed(
                                        context, '/gallery',
                                        arguments: ScreenArguments(
                                            photos: note.photos,
                                            index: index,
                                            noteId: noteModel.id,
                                            subNoteId: note.id)
                                    );
                                    break;
                                  case 'edit':
                                    return showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (_) => SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: BottomModal(
                                              isEdit: true,
                                              editSubNotes: note,
                                              noteModel: noteModel,
                                              selectedDate: noteModel.subNotes[index].isDate,
                                              index: index,
                                            ),
                                          ),
                                        )
                                    );
                                    break;
                                  case 'delete':
                                    context.bloc<NoteCubit>().deleteSubNotes(index, noteModel);
                                    break;
                                }
                              },
                              itemBuilder: (_) => <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  value: 'view',
                                  child: Text('Gallery'),
                                ),
                                new PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                new PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('${note.isDate.month}/${note.isDate.day}/${note.isDate.year}', style: Theme.of(context).textTheme.caption)
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text('${note.title}', style: Theme.of(context).textTheme.caption)
                          )
                        ],
                      )
                    ),
                  ),
                );
              })?.toList() ?? []
            ),
          ),
        ],
      ),
    );
  }
}