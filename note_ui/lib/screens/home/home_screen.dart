import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ui/screens/home/widgets/home_section.dart';
import 'package:note_ui/screens/home/widgets/navbar.dart';
import 'package:note_ui/screens/home/widgets/search_section.dart';
import 'package:note_ui/utils/get_initials.dart';
import 'package:note_ui/widgets/custom_bottom_appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _pageIndex = 0;

  @override
  void initState () {
    init();
    super.initState();
  }

  Future<void> init () async {
    await BlocProvider.of<ThemeCubit>(context).loadTheme();
    BlocProvider.of<NoteCubit>(context).onLoading();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if(state is Theming)
        return Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: NavBar(state: state),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: CustomBottomAppBar(
            state: state,
            isSetState: (i){
              setState(() => _pageIndex = i);
            }
          ),
          body: PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) {
              return SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.vertical,
                fillColor: Color(0xFF111111),
              );
            },
            child: _pageIndex == 0
                ? HomeSection() : SearchSection()
          ),
        );
            else
              return SizedBox();
      },
    );
  }
}
