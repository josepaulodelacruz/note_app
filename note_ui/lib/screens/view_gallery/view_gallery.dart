import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:note_ui/model/screen_argument.dart';

class ViewGallery extends StatefulWidget {
  ScreenArguments arguments;

  ViewGallery({this.arguments});

  @override
  _ViewGalleryState createState () => _ViewGalleryState();
}

class _ViewGalleryState extends State<ViewGallery>{
  CarouselController photoSlider = CarouselController();
  ScreenArguments arguments;
  int currentPhoto;

  @override
  void initState () {
    arguments = widget.arguments;
    currentPhoto = arguments.index + 1;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentPhoto}/${arguments.photos.length}')
      ),
      body: Container(
        color: Colors.black54,
        height: height,
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider(
          carouselController: photoSlider,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: height / 1.5,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            initialPage: arguments.index,
            onPageChanged: (int index, b) {
              setState(() {
                currentPhoto = index + 1;
              });
            }
          ),
          items: arguments.photos?.map((photo) {
            return Hero(
              tag: photo.id,
              child: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.all(0),
                  minScale: 0.5,
                  maxScale: 2,
                  child: Image.file(
                    File(photo.imagePath), fit: BoxFit.contain,
                  ),
                ),
              )
            );
          })?.toList() ?? [],
        )
      )
    );
  }
}