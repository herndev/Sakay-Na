import 'package:flutter/material.dart';

AppBar appbar({title: ""}) {
  return AppBar(
    backgroundColor: Colors.cyan.shade700,
    title: title == ""
        ? Text(
            "Sakay Na",
            style: TextStyle(color: Colors.amber.shade300),
          )
        : title,
  );
}
