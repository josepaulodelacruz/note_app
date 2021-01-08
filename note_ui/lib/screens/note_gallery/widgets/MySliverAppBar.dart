
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:note_common/models/sub_notes.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  SubNotes subNotes;
  final double expandedHeight;
  bool isAnimate = false;
  bool isSelect = false;
  int isSelected = 0;
  final Function funcIsSelect;
  final Function funcEdit;
  final Function funcDelete;


  MySliverAppBar({
    @required this.expandedHeight,
    this.subNotes,
    this.isAnimate,
    this.isSelect,
    this.isSelected,
    this.funcIsSelect,
    this.funcEdit,
    this.funcDelete,
  });

  Widget _fromNow() {
    var fromNow = Jiffy(subNotes.isDate).fromNow();
    return Text(fromNow);
  }

  @override
  Widget build( BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            color: Color(0xFF444444),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Stack(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Gallery ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(isSelect) ...[
                              Text('Selected: ${isSelected}')
                            ],
                            PopupMenuButton(
                              onSelected: (value) async {
                                switch(value) {
                                  case 'select':
                                    funcIsSelect();
                                    break;
                                  case 'edit':
                                    funcEdit();
                                    break;
                                  case 'delete':
                                  // _onDelete();
                                    break;
                                  case 'delete-album':
                                    funcDelete();
                                    break;
                                  default:
                                    break;
                                }
                              },
                              itemBuilder: (_) => <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                  value: 'select',
                                  child: Text(isSelect ? 'Unselect' : 'Select'),
                                ),
                                new PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                new PopupMenuItem<String>(
                                  value: 'delete-album',
                                  child: Text('Delete Album'),
                                ),

                              ],
                            ),
                          ],
                        )
                      )
                    ],
                  )
                ),
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: (1 - shrinkOffset  / expandedHeight ),
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: subNotes.subTitle != "" ? Text(
                              '${subNotes.subTitle}',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                height: 2,
                              )
                            ) : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('No Written Notes', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: _fromNow(),
                          )
                        ],
                      )
                    )
                  ),
                )
              ],
            )
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 10;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
