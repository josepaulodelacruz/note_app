import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
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
  ScreenArguments arguments;
  int currentPhoto;
  PageController pageController;

  @override
  void initState () {
    arguments = widget.arguments;
    currentPhoto = arguments.index + 1;
    pageController = PageController(initialPage: arguments.index);
    BlocProvider.of<NoteCubit>(context).navPage(arguments.index);
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
          title: BlocBuilder<NoteCubit, NoteState>(
            builder: (context, state) {
              if(state is IsPage) {
                return Text('${state.page}/${arguments.photos.length}');
              }
            },
          ) ,
      ),
      body: Container(
          color: Colors.black54,
          height: height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: PhotoViewGallery.builder(
            scrollPhysics: BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              ImageProvider imageProvider = new MemoryImage(loadData(arguments.photos[index].imagePath));
              return PhotoViewGalleryPageOptions(
                imageProvider: imageProvider,
                initialScale: PhotoViewComputedScale.contained ,
                heroAttributes: PhotoViewHeroAttributes(tag: arguments.photos[index].id),
              );
            },
            itemCount: arguments.photos.length,
            loadingBuilder: (context, event) {
              return Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                  ),
                ),
              );
            },
            pageController: pageController,
            onPageChanged: (int i) {
              BlocProvider.of<NoteCubit>(context).navPage(i);
            },
          ),
        )
      );
  }

  Uint8List loadData(imagePath) {
    File file = File(imagePath);
    Uint8List bytes = file.readAsBytesSync();
    return bytes;
  }
}