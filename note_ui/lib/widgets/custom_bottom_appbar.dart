
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_ui/screens/notes_view/widgets/note_card.dart';

class CustomBottomAppBar extends StatelessWidget {
  final state;

  CustomBottomAppBar({this.state});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.search), onPressed: () {
              BlocProvider.of<NoteCubit>(context).test();
            }),
            IconButton(icon: Icon(Icons.wb_sunny_outlined), onPressed: () {
              BlocProvider.of<ThemeCubit>(context).changeTheme(state.enableTheme);
            }),
          ],
        )
    );
  }
}
