import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  MobileAdTargetingInfo targetingInfo;
  InterstitialAd myBanner;
  bool disposed = false;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  var _imagePath;
  bool _isCamera = false;
  bool _trigger = false;

  InterstitialAd buildBannerAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        listener: (MobileAdEvent event) {
          if(event == MobileAdEvent.loaded) {
            if(disposed) {
              myBanner.dispose();
            } else {
              myBanner..show(
                  anchorType: AnchorType.bottom,
                  anchorOffset: MediaQuery.of(context).size.height * 0.12
              );
            }
          }
        }
    );
  }

  @override
  void initState () {
    super.initState();
    _controller = CameraController(
      widget.args.firstCamera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
    _imagePath = widget.args.photos.isEmpty ?
        ""  : widget.args.photos[0].imagePath
        ?? "";

    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _isCamera = true;
      });

    });
    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );
    myBanner =  buildBannerAd()..load();
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
      _cardDialogImage(path).then((res) {
        setState(() {
          _imagePath = path;
        });
      });
      _cameraShutter();
    } catch (e) {
      print(e);
    }
  }

  bool _cameraShutter () {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _trigger = true;
      });
    });
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _trigger = false;
      });
    });
  }

  Future<void> _cardDialogImage (path) async {
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
  void dispose () {
    myBanner?.dispose();
    _controller.dispose();
    super.dispose();
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
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey,
                      child: _isCamera ? Stack(
                        children: [
                          CameraPreview(_controller),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 50),
                            opacity: _trigger ? 0.5 : 0,
                            child: Container(
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                          : SizedBox(),
                    ),
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context, '/gallery',
                                arguments: ScreenArguments(
                                  photos: widget.args.photos,
                                  noteId: widget.args.noteId,
                                  subNoteId: widget.args.subNoteId,
                                  index: 0,
                                )
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF111111),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: _imagePath != '' ? Image.file(
                                File(_imagePath),
                                fit: BoxFit.fill,
                              ) : SizedBox(),
                            ),
                          ),
                        ],
                      )
                    )
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: Icon(Icons.camera),
      ),
    );
  }
}
