import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/pictures.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/widgets/bottom_modal.dart';
import 'package:note_ui/widgets/confirmation_modal.dart';
import 'package:reorderables/reorderables.dart';

class NoteGalleryScreen extends StatefulWidget {
  ScreenArguments arguments;

  NoteGalleryScreen({this.arguments});

  @override
  _NoteGalleryScreenState createState () => _NoteGalleryScreenState();

}

class _NoteGalleryScreenState extends State<NoteGalleryScreen>{
  NoteModel noteModel;
  int _isSelected = 0;
  bool _isSelect = false;
  bool _isArrange = false;
  List<Photo> _photos = List<Photo>();

  @override
  void initState () {
    super.initState();
    _photos = widget.arguments.photos;
    BlocProvider.of<NoteCubit>(context).listen((state) {
      if(state is LoadedNoteState) {
        NoteModel a = 
            state.notes.firstWhere((note) => widget.arguments.noteId == note.id, orElse: () => null);
        if(mounted) {
          setState(() {
            noteModel = a;
          });
        }
      }
    });
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
              onSelected: (value) async {
                switch(value) {
                  case 'select':
                    setState(() {
                      _isSelect = !_isSelect;
                    });
                    _unSelectAll();
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
                              editSubNotes: widget.arguments.subNotes,
                              noteModel: widget.arguments.noteModel,
                              selectedDate: widget.arguments.noteModel.subNotes[widget.arguments.index].isDate,
                              index: widget.arguments.index,
                            ),
                          ),
                        )
                    );
                    break;
                  case 'delete':
                    _onDelete();
                    break;
                  case 'delete-album':
                    BlocProvider.of<NoteCubit>(context).deleteSubNotes(widget.arguments.index, widget.arguments.noteModel);
                    Navigator.pop(context);
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
                new PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                new PopupMenuItem<String>(
                  value: 'delete-album',
                  child: Text('Delete Album'),
                ),

              ],
            ),
          ],
        ),
        body: _picGrid(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if(!_isSelect) {
              final cameras = await availableCameras();
              final firstCamera = cameras.first;
              Navigator
                  .pushNamed(
                  context, '/camera',
                  arguments: ScreenArguments(
                      firstCamera: firstCamera,
                      noteId: widget.arguments.noteId,
                      subNoteId: widget.arguments.subNoteId,
                      photos: widget.arguments.photos));
            } else {
              _onDelete();
            }

          },
          child: Icon(_isSelect ? Icons.delete : Icons.photo_camera),
        ),
      ),
    );
  }

  Widget _picGrid () {
    double height = MediaQuery.of(context).size.height * 0.20;
    double width = MediaQuery.of(context).size.width * 0.30;
    return ReorderableWrap(
      padding: EdgeInsets.all(5.0),
      minMainAxisCount: 3,
      maxMainAxisCount: 3,
      children: _photos.map((pic) {
        int index = _photos.indexOf(pic);
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
              Navigator
                .pushNamed(context,'/gallery-view',
                  arguments: ScreenArguments(
                  photos: _photos,
                  index: index)
              );
            }
          },
          child: Hero(
            tag: pic.id,
            child: Card(
              child: Opacity(
                opacity: pic.isSeleted == true ? 0.3 : 1,
                child: Stack(
                  children: [
                    Image.file(File(pic.imagePath), fit: BoxFit.cover, height: height, width: width),
                    if(_isArrange) ...[
                      Chip(label: Text('${index + 1}')),
                    ],
                    if(pic.isSeleted == true) ...[
                      Icon(Icons.check_circle),
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
      onReorder: _onReorder,
      onReorderStarted: (int index) {
        setState(() {
          _isArrange = true;
        });
      },
      onNoReorder: (int index) {
        setState(() {
          _isArrange = false;
        });
        debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
      },
    );
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

  void _onDelete () async {
    await showDialog(
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
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _isArrange = false;
      _photos.insert(newIndex, _photos.removeAt(oldIndex));
    });
    context.bloc<NoteCubit>().arrangeImage(
      widget.arguments.noteId,
      widget.arguments.subNoteId,
      _photos,
    );
  }

}
