import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ui/utils/custom_snackbar.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NoteCubit>(context).onLoading();
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if(state is Theming)
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Home'),
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  if(value == 'add') {
                    Navigator.pushNamed(context, '/add');
                  } else {
                    context.bloc<ThemeCubit>().changeTheme(state.enableTheme);
                  }

                },
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                    value: 'add',
                    child: Text('Add Notes'),
                  ),
                  new PopupMenuItem<String>(
                    value: 'search',
                    child: Text('Search Notes'),
                  ),
                  new PopupMenuItem<String>(
                    value: 'theme',
                    child: Text('Enable ${state.enableTheme ? 'Dark' : 'Light'} theme'),
                  ),
                ],
              ),
            ],
          ),
          body: BlocListener<NoteCubit, NoteState>(
            listener: (BuildContext context, NoteState state) {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: BlocBuilder<NoteCubit, NoteState>(
                builder: (context, state) {
                  if(state is LoadingNoteState) {
                    return Center(child: CircularProgressIndicator());
                  } else if(state is LoadedNoteState) {
                    return ListView(
                      children: state.notes?.map((note) {
                        return Card(
                          child: ListTile(
                            title: Text(note.title),
                            subtitle: Text(note.description),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/view', arguments: NoteModel(note.id, note.title, note.description));
                                },
                                icon: Icon(Icons.arrow_forward_ios)
                            ),
                          ),
                        );
                      })?.toList() ?? [],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              )
            ),
          )
        );
            else
              return SizedBox();
      },
    );
  }

  Widget _noteCard (BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * 0.90,
      child: Card(
        child: ListTile(
          title: Text('TESTING'),
          subtitle: Text('Sub Title'),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }

}