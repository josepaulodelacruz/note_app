import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ui/screens/home/widgets/navbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState () {
    BlocProvider.of<NoteCubit>(context).onLoading();
    BlocProvider.of<ThemeCubit>(context).loadTheme();
    super.initState();
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
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                if(state is LoadingNoteState) {
                  return Center(child: CircularProgressIndicator());
                } else if(state is LoadedNoteState) {
                  return ListView(
                    children: state.notes?.map((note) {
                      return _noteCard(context, note);
                    })?.toList() ?? [],
                  );
                } else {
                  return SizedBox();
                }
              },
            )
          ),
        );
            else
              return SizedBox();
      },
    );
  }

  Widget _noteCard (BuildContext context, note) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * 0.90,
      child: Card(
        child: ListTile(
          title: Text(note.title),
          subtitle: Text(note.description),
          trailing: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/view', arguments: NoteModel(note.id, note.title, note.description, subNotes: note.subNotes));
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }

}
