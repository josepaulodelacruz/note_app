import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/bloc/theme/theme_cubit.dart';
import 'package:note_common/bloc/theme/theme_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/screens/home/widgets/home_section.dart';
import 'package:note_ui/screens/home/widgets/navbar.dart';
import 'package:note_ui/screens/home/widgets/search_section.dart';
import 'package:note_ui/widgets/custom_bottom_appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
  with TickerProviderStateMixin {

  Animation<double> _myAnimation;
  AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _searchInput = TextEditingController();
  int _pageIndex = 0;
  List<NoteModel> noteModels;
  List<NoteModel> searchNotes;
  bool isView = false;

  @override
  void initState () {
    super.initState();
    BlocProvider.of<NoteCubit>(context).onLoading();
    BlocProvider.of<NoteCubit>(context).listen((state) {
      if(state is LoadedNoteState) {
        if(mounted) {
          setState(() {
            noteModels = state.notes;
          });
        }
      }
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _controller.forward();
    _myAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if(state is Theming)
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: NavBar(
              state: state,
              event: () {
                setState(() {
                  isView = !isView;
                });
                isView ?
                    _controller.reverse() : _controller.forward();
              },
              animatedIcon: AnimatedIcon(
                icon: AnimatedIcons.list_view,
                progress: _myAnimation,
              )
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: CustomBottomAppBar(
            state: state,
            isSetState: (i){
              setState(() => _pageIndex = i);
            }
          ),
          body: PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) {
              return SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.vertical,
                fillColor: Color(0xFF111111),
              );
            },
            child: _pageIndex == 0 ?
              HomeSection(
                  notes: noteModels,
                  isView: isView) :
              SearchSection(
                notes: searchNotes,
                input: _searchInput,
                clearText: () {
                  setState(() {
                    _searchInput.text = '';
                    searchNotes = [];
                  });
                },
                fuzzySearch: () {
                  setState(() {
                    searchNotes =
                      _searchInput.text == '' ? [] :
                        noteModels.where((note) =>
                        note.title.toString().toLowerCase().contains(_searchInput.text.toString().toLowerCase())).toList();
                  });
                },
              ),
          ),
        );
            else
              return SizedBox();
      },
    );
  }
}
