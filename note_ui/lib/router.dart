import 'package:flutter/material.dart';
import 'package:note_ui/screens/home/home_screen.dart';
import 'package:note_ui/screens/notes_add/add_note_screend.dart';
import 'package:note_ui/screens/notes_view/note_view_screen.dart';
import 'package:note_ui/screens/router_const.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case addNotes:
        return MaterialPageRoute(builder: (_) => AddNoteScreen());
      case viewNotes:
        return MaterialPageRoute(builder: (_) => NoteViewScreen(noteModel: settings.arguments));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No defined Routes')),
          )
        );
    }
  }
}