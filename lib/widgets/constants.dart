import 'package:flutter/material.dart';

class Constants{
  final primarycolor = Color.fromARGB(255,134,107,252);
  final secondarycolor= Color(0xffa16cfd);
  final tertiary=Color(0xff105cf1);
  final blackcolor=Color(0xff000000);
  final greycolor=Color(0xffd9dadb);

  final lineargradientblue=LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.topLeft,
      colors: <Color>[Color(0xff738997),Color(0xff9AC6f3)],
      stops:[0,1]);

  final lineargradientpurple =LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: <Color>[Color(0xff51087e),Color(0xff6C0BA9)],
      stops:[0,1]);
}
final Shader shader = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    Color(0xffd9dadb), // light grey
    Color(0xffa6a6a6), // medium grey
    Color(0xff7d7d7d), // dark grey
  ],
  stops: [0.0, 0.5, 1.0],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


