import 'package:flutter/material.dart';

void showConfirmSnackBar (GlobalKey<ScaffoldState> scaffoldKey, String msg) {
  scaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text(msg)),
  );
}