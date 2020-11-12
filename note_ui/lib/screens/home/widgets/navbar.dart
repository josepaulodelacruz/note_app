import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_ui/utils/appbar_shape.dart';

class NavBar extends StatelessWidget {
  final state;
  final AnimatedIcon animatedIcon;
  final Function event;

  const NavBar({Key key, this.state, this.animatedIcon, this.event});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: appBarShape(0),
      title: Text('Home'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => event(),
            child: Center(
              child: animatedIcon,
            ),
          ),
        )
      ],
    );
  }
}

