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
  int _isSelected = 0;
  bool _isSelect = false;
  ScrollController _scrollController = ScrollController();
  List<Pictures> _photos = List<Pictures>();

  @override
  void initState () {
    super.initState();
    _photos = widget.arguments.photos;
  }

  void _unSelectAll () {
    if(!_isSelect) {
      _unSelectItem();
      setState(() {
        _isSelected = 0;
      });
    }
  }

  void _unSelectItem () {
    _photos.map((e) {
      int index = _photos.indexOf(e);
      setState(() {
        _photos[index].isSeleted = false;
      });
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _unSelectItem();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _unSelectItem();
              Navigator.pop(context);
            },
          ),
          title: Text('Gallery'),
          actions: [
            if(_isSelect) ...[
              Align(
                alignment: Alignment.center,
                child: Text('Selected: ${_isSelected}'),
              )
            ],
            PopupMenuButton(
              onSelected: (value) {
                switch(value) {
                  case 'select':
                    setState(() {
                      _isSelect = !_isSelect;
                    });
                    _unSelectAll();
                    break;
                  case 'delete':
                    showDialog(
                      context: context,
                      builder: (_) => ConfirmationModal(
                        titleType: 'Photos',
                        handle: () {
                          setState(() {
                            _photos.removeWhere((p) => p.isSeleted == true);
                            _isSelected = 0;
                            _isSelect = false;
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
                  child: Text(_isSelect ? 'Unselect' : 'Select'),
                ),
                if(_isSelect) ...[
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ]
              ],
            ),
          ],
        ),
        body: _grid(),
      ),
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
            if(_isSelect) {
              setState(() {
                _photos[index].isSeleted = !pic.isSeleted;
                if(_photos[index].isSeleted) {
                  _isSelected++;
                } else {
                  _isSelected--;
                }
              });
            } else {
            }
          },
          child: Hero(
            tag: pic.id,
            child: Card(
              child: Opacity(
                opacity: pic.isSeleted == true ? 0.3 : 1,
                child: Image.file(File(pic.imagePath), fit: BoxFit.cover)
              ),
            ),
          ),
        );
      },
    );
  }
}