
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';

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
            IconButton(icon: Icon(Icons.search), onPressed: () {},),
            IconButton(icon: Icon(Icons.menu), onPressed: () {
              BlocProvider.of<ThemeCubit>(context).changeTheme(state.enableTheme);
            }),
          ],
        )
    );
  }
}
