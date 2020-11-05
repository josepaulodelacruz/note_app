import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';

class MockNoteCubit extends MockBloc<NoteModel> implements NoteCubit {}

void main () {

  group('test', () async {
    test('test', () async {
      final cubit = MockNoteCubit();
      whenListen(cubit, cubit);
      expect(cubit, cubit);

    });
  });
}


