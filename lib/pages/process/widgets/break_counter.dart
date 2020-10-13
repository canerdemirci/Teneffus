import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teneffus/constants.dart';

class BreakCounter extends StatefulWidget {
  final int countDownMinute;
  final double size;
  final bool start;
  final bool isInOrder;
  final Function onFinished;
  final Function onTick;

  const BreakCounter({
    Key key,
    @required this.countDownMinute,
    @required this.size,
    this.start = false,
    @required this.isInOrder,
    @required this.onFinished,
    @required this.onTick,
  }) : super(key: key);

  @override
  _BreakCounterState createState() => _BreakCounterState();
}

class _BreakCounterState extends State<BreakCounter> {
  Timer _breakTimer;
  int _seconds;
  bool _isFinished;

  void _breakOnTick(Timer tm) {
    if (!_isFinished)
      setState(() {
        _seconds--;
        widget.onTick();
        if (_seconds <= 0) {
          _isFinished = true;
          widget.onFinished();
          _breakTimer.cancel();
        }
      });
  }

  void _initCounter() {
    _isFinished = false;
    _seconds = widget.countDownMinute * 60;
  }

  @override
  void initState() {
    super.initState();

    _initCounter();
  }

  @override
  void dispose() {
    if (_breakTimer != null) _breakTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start && _breakTimer == null)
      _breakTimer = Timer.periodic(Duration(seconds: 1), _breakOnTick);

    int secondToMinute = (_seconds ~/ 60) + 1;
    int counterCaption = secondToMinute > widget.countDownMinute
        ? secondToMinute - 1
        : secondToMinute;

    Widget counterCaptionText = Text(
      '$counterCaption',
      style: timerCircleStyle.copyWith(fontSize: widget.size / 4.1667),
    );
    Widget counterCaptionIcon = Icon(Icons.check_circle,
        size: widget.size / 3.3333, color: Color(0xFFFFC700));

    return CustomPaint(
      painter: _BreakCounterPainter(
        countDownMinute: widget.countDownMinute,
        currentSecond: _seconds,
        isFinished: _isFinished,
        isInOrder: widget.isInOrder,
      ),
      child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          child: !_isFinished ? counterCaptionText : counterCaptionIcon),
    );
  }
}

class _BreakCounterPainter extends CustomPainter {
  final int countDownMinute;
  final int currentSecond;
  final bool isFinished;
  final bool isInOrder;

  const _BreakCounterPainter({
    @required this.countDownMinute,
    @required this.currentSecond,
    @required this.isFinished,
    @required this.isInOrder,
  });

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
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;

    // Shadow circle
    _arc(canvas, paint, Colors.grey[400], size, 0, startRadians, endRadians);

    // Base circle
    _arc(canvas, paint, Colors.grey[100], size, isInOrder ? 5 : 0, startRadians,
        endRadians);

    // Blue progress circle
    _arc(
        canvas,
        paint,
        !isFinished ? Color(0xFF8BC7FF) : Color(0xFFFFC700),
        size,
        isInOrder ? 5 : 0,
        startRadians,
        (((countDownMinute * 60) - currentSecond) / (countDownMinute * 60)) *
            endRadians);

    // Inner circle
    _arc(canvas, paint, Colors.grey[200], size, 20, startRadians, endRadians);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
