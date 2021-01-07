import 'dart:async';

import 'package:animations/animations.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/screens/notes_view/widgets/album_section.dart';
import 'package:note_ui/screens/notes_view/widgets/collections_section.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class NoteViewScreen extends StatefulWidget {
  NoteModel noteModel;

  NoteViewScreen({this.noteModel}) : super();

  @override
  _NoteViewScreenState createState () => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen>{
  MobileAdTargetingInfo targetingInfo;
  BannerAd myBanner;
  bool disposed = false;
  NoteModel noteModel;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();
  SubNotes subNotes;
  bool isView = false;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if(event == MobileAdEvent.loaded) {
            if(disposed) {
              myBanner.dispose();
            } else {
              myBanner..show(
                  anchorType: AnchorType.bottom,
                  anchorOffset: MediaQuery.of(context).size.height * 0.85
              );

              Timer.periodic(Duration(seconds: 3), (timer) {
                hideBanner();
              });
            }
          }
        }
    );
  }

  @override
  void initState () {
    super.initState();
    noteModel = widget.noteModel;
    subNotes = noteModel.subNotes.isEmpty ? null : noteModel.subNotes[0];
    BlocProvider.of<NoteCubit>(context).listen((state) {
      if(state is LoadedNoteState) {
        NoteModel a =
        state.notes.firstWhere((note) => note.id == noteModel.id, orElse: () => null);
        if(mounted) {
          setState(() {
            noteModel = a != null ?
            a : widget.noteModel;
            subNotes =
            noteModel.subNotes.isEmpty ? null : noteModel.subNotes[0];
          });
        }
      }
    });

    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );

    myBanner =  buildBannerAd()..load();
  }

  void displayBanner() async {
    disposed = false;
    if(myBanner == null) myBanner = buildBannerAd();
    myBanner.load();
  }

  void hideBanner() async {
    await myBanner?.dispose();
    disposed = true;
    myBanner = null;
  }

  @override
  void dispose() {
    myBanner?.dispose();
    hideBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(
          noteModel: noteModel,
          newTitle: _newTitle,
          newDescription: _newDescription,
          isView: isView,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              fillColor: Color(0xFF111111),
            );
          },
          child: !isView ? CollectionsSection(
            noteModel: noteModel,
            subNotes: subNotes,
            newTitle: _newTitle,
            newDescription: _newDescription,
            isView: isView,
            expand: (view) => setState(() => isView = view),
            isSetState: (note) {
              setState(() {
                subNotes =
                note.photos.isEmpty ? null : note;
              });
            },
          ) :
          AlbumSection(
            isView: isView,
            noteModel: noteModel,
            expand: (view) => setState(() => isView = view),
            renderBottomModal: () {
              return showModalBottomSheet(
                context: context,
                builder: (_) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: BottomModal(
                      noteModel: noteModel,
                      selectedDate: selectedDate,
                    ),
                  )
                )
              );
            },
          )
        )
      )
    );
  }
}