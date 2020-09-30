import 'package:bloc/bloc.dart';

class NoteObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    // TODO: implement onChange
    print(change);
    super.onChange(cubit, change);
  }
}