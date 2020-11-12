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
      shape: appBarShape(0),
      title: Text('Home'),
    );
  }
}

