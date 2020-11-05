import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_common/api/change_theme_api.dart';
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

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = NoteObserver();
  Bloc.observer = ThemeObserver();
  Hive.initFlutter();
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
          create: (_) => ThemeCubit(Theming(false), ChangeThemeApi()),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          if(state is Theming) {
            return MaterialApp(
              title: 'Notes Application',
              theme: state.enableTheme ? ThemeData(
                scaffoldBackgroundColor: Colors.grey[200],
                buttonColor: Colors.lightBlueAccent,
                appBarTheme: AppBarTheme(
                  color: Colors.lightBlueAccent,
                ),
              ) : ThemeData.dark(),
              initialRoute: '/',
              onGenerateRoute: OnRouter.Router.generateRoute,
            );
          } else {
            return SizedBox();
          }
        }
      ),
    );
  }
}
