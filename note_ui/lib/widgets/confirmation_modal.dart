import 'package:flutter/material.dart';

class ConfirmationModal extends StatelessWidget {
  final Function handle;
  String titleType;

  ConfirmationModal({this.handle, this.titleType}) : super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Text('Are you sure you want to delete this Note?'),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
        FlatButton(
          onPressed: handle,
          child: Text('Yes'),
        )
      ],
    );
  }
}