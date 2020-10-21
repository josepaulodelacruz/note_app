import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}