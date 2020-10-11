import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePhotoScreen extends StatefulWidget {
  CameraDescription camera;

  TakePhotoScreen({
    Key key,
    @required this.camera
  }) : super(key: key);

  @override
  _TakePhotoScreen createState () => _TakePhotoScreen();

}

class _TakePhotoScreen extends State<TakePhotoScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState () {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose () {
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
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}