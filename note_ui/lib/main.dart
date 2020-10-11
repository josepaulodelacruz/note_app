import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_ui/router.dart' as OnRouter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_observer.dart';
import 'package:note_common/bloc/theme/theme_observer.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = NoteObserver();
  Bloc.observer = ThemeObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NoteCubit(InitialState()),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(Theming(false)),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            if(state is Theming) {
              return  MaterialApp(
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
