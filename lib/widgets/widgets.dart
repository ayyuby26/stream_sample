import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Widgets {
  static showSnackBar(BuildContext context, String msg) {
    final _snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
}
