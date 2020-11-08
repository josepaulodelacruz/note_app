import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/screens/home/widgets/navbar.dart';
import 'package:note_ui/utils/get_initials.dart';
import 'package:note_ui/widgets/custom_bottom_appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
//              context.bloc<NoteCubit>().test();
              Navigator.pushNamed(context, '/add');
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: CustomBottomAppBar(state: state),
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: BlocBuilder<NoteCubit, NoteState>(
                  builder: (context, state) {
                    if(state is LoadingNoteState) {
                      return Center(child: CircularProgressIndicator());
                    } else if(state is LoadedNoteState) {
                      return ListView(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: state.notes?.map((note) {
                            return _noteCard(context, note);
                          })?.toList() ?? [],
                        ).toList(),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                )
              ),
            ],
          ),

        );
            else
              return SizedBox();
      },
    );
  }

  Widget _noteCard (BuildContext context, NoteModel note) {
    final _title = note.checkIfNull() ?
        getInitials(title: note.title) : note.coverPhoto;
    print('note: ${note.coverPhoto}');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * 0.90,
      child: ListTile(
        leading: note.coverPhoto == null ?
          CircleAvatar(
            radius: 20,
            child: Text(_title)) :
          Image.file(File(note.coverPhoto), fit: BoxFit.cover),
        title: Text(note.title, style: Theme.of(context).textTheme.bodyText1),
        subtitle: Text(note.description),
        trailing: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/view', arguments: NoteModel(note.id, note.title, note.description, subNotes: note.subNotes));
          },
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

}
