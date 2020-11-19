
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:note_common/api/note_api.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:mockito/mockito.dart';

class MockNoteCubit extends Mock implements NoteCubit {
  MockNoteApi mockNoteApi;

  MockNoteCubit(this.mockNoteApi);
}


class MockNoteApi extends Mock implements NoteApi {}


void main () {
  MockNoteCubit mockNoteCubit;

  setUp(() {
    mockNoteCubit = MockNoteCubit(MockNoteApi());
    Hive.init('data/user/0/com.jeyps.lazy_notes');
  });

  group('test', ()  {
    blocTest<NoteCubit, NoteState>(
      'emits [LoadedNoteState]',
      build: () => NoteCubit(NoteApi()),
      act: (NoteCubit cubit) => cubit.addNote('test', 'test'),
      expect: <Matcher>[
        isA<LoadedNoteState>(),
      ]
    );
  });
}


