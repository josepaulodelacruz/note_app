import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:note_ui/model/screen_argument.dart';

class ViewGallery extends StatelessWidget {
  ScreenArguments arguments;

  ViewGallery({this.arguments});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('${arguments.index + 1}/${arguments.photos.length}')
      ),
      body: Container(
        color: Colors.black54,
        height: height,
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: height / 1.5,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            initialPage: arguments.index,
          ),
          items: arguments.photos?.map((photo) {
            return Hero(
              tag: photo.id,
              child: Center(
                child: Image.file(File(photo.imagePath), fit: BoxFit.fill),
              )
            );
          })?.toList() ?? [],
        )
      )
    );
  }
}