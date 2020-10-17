import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/screens/take_photo/widgets/image_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:uuid/uuid.dart';

class TakePhotoScreen extends StatefulWidget {
  ScreenArguments args;

  TakePhotoScreen({
    Key key,
    @required this.args,
  }) : super(key: key);

  @override
  _TakePhotoScreen createState () => _TakePhotoScreen();

}

class _TakePhotoScreen extends State<TakePhotoScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  StreamSubscription<HardwareButtons.VolumeButtonEvent> _volumeButtonSubscription;

  @override
  void initState () {
    super.initState();
    _volumeButtonSubscription = HardwareButtons.volumeButtonEvents.listen((e) {
      _takePhoto();
    });
    _controller = CameraController(
      widget.args.firstCamera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose () {
    _controller.dispose();
    _volumeButtonSubscription?.cancel();
    super.dispose();
  }

  void _takePhoto () async {
    var uuid = Uuid();
    String id = uuid.v4();
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${id}.png',
      );
      await _controller.takePicture(path);
      _cardDialogImage(path);
    } catch (e) {
      print(e);
    }
  }

  _cardDialogImage (path) async {
    BlocProvider
        .of<NoteCubit>(context)
        .addImage(
          path,
          widget.args.noteId,
          widget.args.subNoteId);
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, animation1, animation2) {},
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeOutCirc.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: ImageCard(path: path),
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onDoubleTap: () async {
                _takePhoto();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 6,
                    child: CameraPreview(_controller),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.white
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.white
                          )
                        ],
                      )
                    )
                  )

                ],
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _takePhoto();
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}