import 'package:flutter/material.dart';

class TakePhotoScreen extends StatefulWidget {
  @override
  _TakePhotoScreen createState () => _TakePhotoScreen();

}

class _TakePhotoScreen extends State<TakePhotoScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
    );
  }
}