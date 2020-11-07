import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_ui/utils/appbar_shape.dart';

class NavBar extends StatelessWidget {
  final state;

  const NavBar({Key key, this.state});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: appBarShape(20),
      title: Text('Home'),
//      actions: [
//        PopupMenuButton(
//          onSelected: (value) {
//            if(value == 'add') {
//              Navigator.pushNamed(context, '/add');
//            } else {
//              context.bloc<ThemeCubit>().changeTheme(state.enableTheme);
//            }
//          },
//          itemBuilder: (_) => <PopupMenuItem<String>>[
//            new PopupMenuItem<String>(
//              value: 'add',
//              child: Text('Add Notes'),
//            ),
//            new PopupMenuItem<String>(
//              value: 'search',
//              child: Text('Search Notes'),
//            ),
//            new PopupMenuItem<String>(
//              value: 'theme',
//              child: Text('Enable ${state.enableTheme ? 'Dark' : 'Light'} theme'),
//            ),
//          ],
//        ),
//      ],
    );
  }
}

