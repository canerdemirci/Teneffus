import 'package:flutter/material.dart';

class Responsive {
  static final int mobileMaxWidth = 425;

  final MediaQueryData mediaQueryData;

  const Responsive({@required this.mediaQueryData});

  bool get isMobile => mediaQueryData.size.width <= mobileMaxWidth;
  double get screenWidth => mediaQueryData.size.width;
}
