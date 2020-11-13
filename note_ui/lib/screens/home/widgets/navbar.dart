import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final AnimatedIcon animatedIcon;
  final Function event;

  const NavBar({Key key, this.animatedIcon, this.event});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Home'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => event(),
            child: Center(
              child: animatedIcon,
            ),
          ),
        )
      ],
    );
  }
}

