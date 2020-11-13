
import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final state;
  Function isSetState;

  CustomBottomAppBar({this.state, this.isSetState});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {
              isSetState(0);
            }),
            IconButton(icon: Icon(Icons.search), onPressed: () {
              isSetState(1);
            }),
          ],
        )
    );
  }
}
