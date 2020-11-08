import 'package:flutter/material.dart';

import '../../../constants.dart';

class CounterCircle extends StatelessWidget {
  final double size;
  final List<int> percentages;
  final List<Color> percColors;
  final bool shadow;
  final Widget caption;
  final double animPos;
  final bool anim;

  const CounterCircle({
    Key key,
    @required this.size,
    @required this.caption,
    @required this.percentages,
    @required this.percColors,
    this.shadow = false,
    this.anim = false,
    this.animPos = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CounterPainter(
        shadow: shadow,
        percentages: percentages,
        percColors: percColors,
        anim: anim,
        animPos: animPos,
      ),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: caption,
      ),
    );
  }
}

class _CounterPainter extends CustomPainter {
  final bool shadow;
  final List<int> percentages;
  final List<Color> percColors;
  final bool anim;
  final double animPos;

  const _CounterPainter(
      {this.shadow = false,
      @required this.percentages,
      @required this.percColors,
      @required this.anim,
      @required this.animPos});

  void _arc(Canvas canvas, Paint paint, Color color, Size size, double offset,
      double start, double end) {
    paint.color = color;
    canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width - offset,
          height: size.height - offset,
        ),
        start,
        end,
        true,
        paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Color shadowColor = Colors.grey[400];
    final Color baseColor = Colors.grey[100];
    final Color innerColor = Colors.grey[200];
    final Color animColor = Colors.grey[300];

    final Paint paint = Paint();
    paint.style = PaintingStyle.fill;

    // Shadow circle
    if (shadow)
      _arc(canvas, paint, shadowColor, size, 0, startRadians, endRadians);

    // Base circle
    _arc(canvas, paint, baseColor, size, shadow ? 10 : 0, startRadians,
        endRadians);

    // Progress circles
    for (int i = 0; i < percentages.length; i++)
      _arc(
        canvas,
        paint,
        percColors[i] ?? Colors.transparent,
        size,
        shadow ? 10 : 0,
        startRadians,
        endRadians * percentages[i] / 100,
      );

    // Inner circle
    _arc(canvas, paint, innerColor, size, shadow ? 30 : 25, startRadians,
        endRadians);

    // Animation circles
    if (anim) _arc(canvas, paint, animColor, size, 30, animPos, endRadians / 4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
