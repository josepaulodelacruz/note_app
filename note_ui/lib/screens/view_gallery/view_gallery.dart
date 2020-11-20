import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
    final double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(
            title: Text('${currentPhoto}/${arguments.photos.length}')
        ),
        body: Container(
            color: Colors.black54,
            height: height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: PhotoViewGallery.builder(
              onPageChanged: (int i) {
                setState(() {
                  currentPhoto = i + 1;
                });
              },
              scrollPhysics: BouncingScrollPhysics(),
              itemCount: arguments.photos.length,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: AssetImage(arguments.photos[index].imagePath),
                  initialScale: PhotoViewComputedScale.contained * 0.9,
                  heroAttributes: PhotoViewHeroAttributes(tag: arguments.photos[index].id),
                );
              },
            ),
        )
    );
  }
}