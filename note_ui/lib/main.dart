import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_common/api/change_theme_api.dart';
import 'package:note_common/api/storage_api.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/theme.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_common/models/pictures.dart';

import 'package:note_ui/router.dart' as OnRouter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_observer.dart';
import 'package:note_common/bloc/theme/theme_observer.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_common/api/note_api.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = NoteObserver();
  Bloc.observer = ThemeObserver();
  var dir = await getApplicationDocumentsDirectory();
  Hive.initFlutter(dir.path);
  Hive.registerAdapter(ThemeAdapter());
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(SubNotesAdapter());
  Hive.registerAdapter(PhotoAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NoteCubit(NoteApi()),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(Theming(), ChangeThemeApi()),
        )
      ],
      child: MaterialApp(
        title: 'Notes Application',
        theme: ThemeData(
          brightness: Brightness.dark,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF777777)
          ),
          buttonColor: Colors.lightBlueAccent,
          scaffoldBackgroundColor: Color(0xFF111111),
          textTheme: TextTheme(
            caption: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: OnRouter.Router.generateRoute,
      )
    );
  }
}
