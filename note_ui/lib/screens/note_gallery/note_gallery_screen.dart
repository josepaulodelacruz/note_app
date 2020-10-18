import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/pictures.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/widgets/confirmation_modal.dart';

class NoteGalleryScreen extends StatefulWidget {
  ScreenArguments arguments;

  NoteGalleryScreen({this.arguments});

  @override
  _NoteGalleryScreenState createState () => _NoteGalleryScreenState();

}

class _NoteGalleryScreenState extends State<NoteGalleryScreen>{
  ScrollController _scrollController = ScrollController();
  List<Pictures> _photos = List<Pictures>();

  @override
  void initState () {
    super.initState();
    _photos = widget.arguments.photos;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              switch(value) {
                case 'delete':
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmationModal(
                      titleType: 'Photos',
                      handle: () {
                        setState(() {
                          _photos.removeWhere((p) => p.isSeleted == true);
                        });
                        BlocProvider.of<NoteCubit>(context).deleteImage(
                            _photos,
                            widget.arguments.noteId,
                            widget.arguments.subNoteId
                        );
                        Navigator.pop(context);
                      },
                    ),
                  );
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                value: 'select',
                child: Text('Select'),
              ),
              new PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: _grid(),
    );
  }

  Widget _grid () {
    return GridView.builder(
      controller: _scrollController,
      itemCount: _photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        Pictures pic = _photos[index];
        return InkWell(
          onTap: () {
            setState(() {
              _photos[index].isSeleted = !pic.isSeleted;
            });
          },
          child: Hero(
            tag: pic.id,
            child: Card(
              child: Opacity(
                opacity: pic.isSeleted == true ? 0.5 : 1,
                child: Image.file(File(pic.imagePath), fit: BoxFit.cover)
              ),
            ),
          ),
        );
      },
    );
  }
}