
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_ui/screens/notes_view/widgets/note_card.dart';

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
//              BlocProvider.of<NoteCubit>(context).test();
            }),
            IconButton(icon: Icon(Icons.search), onPressed: () {
              isSetState(1);
//              BlocProvider.of<ThemeCubit>(context).changeTheme(state.enableTheme);
            }),
          ],
        )
    );
  }
}
