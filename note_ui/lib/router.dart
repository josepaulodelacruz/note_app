import 'package:flutter/material.dart';
import 'package:note_ui/screens/home/home_screen.dart';
import 'package:note_ui/screens/note_gallery/note_gallery_screen.dart';
import 'package:note_ui/screens/notes_add/add_note_screend.dart';
import 'package:note_ui/screens/notes_view/note_view_screen.dart';
import 'package:note_ui/screens/router_const.dart';
import 'package:note_ui/screens/take_photo/take_photo_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case addNotes:
        return MaterialPageRoute(builder: (_) => AddNoteScreen());
      case viewNotes:
        return MaterialPageRoute(builder: (_) => NoteViewScreen(noteModel: settings.arguments));
      case galleryNotes:
        return MaterialPageRoute(builder: (_) => NoteGalleryScreen(arguments: settings.arguments));
      case camera:
        return MaterialPageRoute(builder: (_) => TakePhotoScreen(args: settings.arguments));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No defined Routes')),
          )
        );
    }
  }
}
