import 'package:flutter/material.dart';

class Responsive {
  final MediaQueryData mediaQueryData;

  const Responsive({@required this.mediaQueryData});

  bool get isMobile => mediaQueryData.size.width <= 425;
}
