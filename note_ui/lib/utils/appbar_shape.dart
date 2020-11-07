

import 'package:flutter/material.dart';

RoundedRectangleBorder appBarShape (double curved) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(curved),
    )
  );
}
