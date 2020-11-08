import 'package:flutter/material.dart';
import 'package:teneffus/pages/process/widgets/counter_circle.dart';

class BreakCounter extends StatelessWidget {
  final bool shadow;
  final double size;
  final Widget caption;
  final int percentage;
  final bool isFinished;

  const BreakCounter(
      {Key key,
      this.shadow = false,
      @required this.size,
      this.percentage = 0,
      @required this.caption,
      this.isFinished = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color yellow = Color(0xFFFFC700);
    final Color blue = Color(0xFF8BC7FF);

    return CounterCircle(
      shadow: shadow,
      size: size,
      caption: caption,
      percentages: [percentage],
      percColors: [isFinished ? yellow : blue],
    );
  }
}
