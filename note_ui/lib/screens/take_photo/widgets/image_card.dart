
import 'dart:io';

import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  String path;

  ImageCard({this.path});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: 80,
        color: Colors.white,
        child: Card(
          child: Image.file(File(path), fit: BoxFit.contain),
        )
      )
    );
  }
}