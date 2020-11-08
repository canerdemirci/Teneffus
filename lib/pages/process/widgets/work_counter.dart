import 'package:flutter/material.dart';
import 'package:teneffus/pages/process/widgets/counter_circle.dart';

class WorkCounter extends StatelessWidget {
  final bool shadow;
  final Widget caption;
  final double size;
  final int workPercentage;
  final int pausePercentage;
  final bool isPaused;
  final double animPos;
  final bool anim;

  const WorkCounter({
    Key key,
    @required this.shadow,
    @required this.size,
    @required this.workPercentage,
    @required this.pausePercentage,
    @required this.caption,
    this.isPaused = false,
    this.anim = true,
    this.animPos = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color green = Color(0xFFBCFF93);
    Color red = Color(0xFFFF9393);
    Color grey = Colors.grey[600];

    return CounterCircle(
      shadow: shadow,
      caption: caption,
      size: size,
      percentages: [workPercentage, pausePercentage],
      percColors: [isPaused ? grey : green, red],
      anim: anim,
      animPos: animPos,
    );
  }
}
