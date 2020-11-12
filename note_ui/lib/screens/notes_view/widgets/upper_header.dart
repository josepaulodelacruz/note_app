import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/model/screen_argument.dart';

class UpperHeader extends StatelessWidget {
  NoteModel noteModel;
  SubNotes subNotes;

  UpperHeader({this.noteModel, this.subNotes});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.50,
      child: Stack(
        children: [
          if(noteModel != null ) ...[
            Container(
              child: Opacity(
                opacity: 0.8,
                child: subNotes != null ? CarouselSlider.builder(
                  itemCount: subNotes.photos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Hero(
                          tag: subNotes.photos[index].id,
                          child: Image.file(
                            File(subNotes.photos[index].imagePath),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                          ),
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              Navigator
                                .pushNamed(
                                context, '/gallery',
                                arguments: ScreenArguments(
                                    photos: subNotes.photos,
                                    index: index,
                                    noteId: noteModel.id,
                                    subNoteId: subNotes.id)
                              );
                            },
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xCC000000),
                                const Color(0x00000000),
                                const Color(0x00000000),
                                Colors.black54
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  options: CarouselOptions(
                      enableInfiniteScroll: false,
                      reverse: false,
                      initialPage: 0,
                      height: MediaQuery.of(context).size.height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false
                  ),
                ) : SizedBox(),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                noteModel.title,
                overflow: TextOverflow.ellipsis,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline3,
              ),
            ),
          )
        ],
      )
    );
  }
}