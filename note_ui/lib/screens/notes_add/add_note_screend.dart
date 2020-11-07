import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_ui/screens/home/widgets/inputs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ui/utils/appbar_shape.dart';
import 'package:note_ui/widgets/custom_bottom_appbar.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  createState () => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> with
    TickerProviderStateMixin {
  Animation<double> _myAnimation;
  AnimationController _controller;
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState () {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _myAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: _controller,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: appBarShape(20),
        title: Text('Add Notes'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputCard(
              controller: _title,
              field: 'Title',
            ),
            InputCard(
              controller: _description,
              field: 'Description',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.bloc<NoteCubit>().addNote(_title.text, _description.text);
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      ),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}
