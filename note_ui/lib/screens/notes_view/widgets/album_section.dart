import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class AlbumSection extends StatelessWidget {
  NoteModel noteModel;
  bool isView;
  final Function expand;
  final Function renderBottomModal;

  AlbumSection({this.noteModel, this.isView, this.expand, this.renderBottomModal});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                    onTap: () => expand(false),
                    child: Text('Collections',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: !isView ?
                        Colors.yellowAccent : Colors.white))
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: InkWell(
                    onTap: () => expand(true),
                    child: Text('Albums', style: Theme.of(context).textTheme.subtitle1.copyWith(color: isView ?
                    Colors.yellowAccent : Colors.white))),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: GestureDetector(
                    onTap: () {
                      renderBottomModal();
                    },
                    child: Icon(Icons.add_a_photo)
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Divider(thickness: 2),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                padding: const EdgeInsets.all(8),
                childAspectRatio: 1,
                children: noteModel.subNotes?.map((note) {
                  int index = noteModel.subNotes.indexOf(note);
                  return GridTile(
                      footer: Material(
                        color: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: GridTileBar(
                          backgroundColor: Colors.black45,
                          title: Text(note.title, style: Theme.of(context).textTheme.bodyText1),
                        ),
                      ),
                      child: Container(
                        color: Color(0xFF333333),
                        child: InkWell(
                            onTap: () {
                            },
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
                                          BlocProvider.of<NoteCubit>(context).deleteSubNotes(index, noteModel);
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
                      )
                  );
                })?.toList() ?? [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}