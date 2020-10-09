import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teneffus/constants.dart';

class MolaCircle extends StatefulWidget {
  final int timerMinute;
  final bool start;
  final bool isInOrder;
  final Function onFinished;
  final Function onTick;

  const MolaCircle({
    Key key,
    @required this.timerMinute,
    this.start = false,
    @required this.isInOrder,
    @required this.onFinished,
    @required this.onTick,
  }) : super(key: key);

  @override
  _MolaCircleState createState() => _MolaCircleState();
}

class _MolaCircleState extends State<MolaCircle> {
  Timer _molaTimer;
  int _seconds;

  bool _isFinished;

  void _timerCallback(Timer tm) {
    if (!_isFinished)
      setState(() {
        _seconds--;
        if (!_isFinished) widget.onTick();
        if (_seconds == 0) {
          _isFinished = true;
          widget.onFinished();
          _molaTimer.cancel();
        }
      });
  }

  @override
  void initState() {
    super.initState();

    _seconds = 0;
    _isFinished = false;
    _seconds = widget.timerMinute * 60;
  }

  @override
  void dispose() {
    if (_molaTimer != null) _molaTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start && _molaTimer == null)
      _molaTimer = Timer.periodic(Duration(seconds: 1), _timerCallback);

    int secondToMinute = (_seconds ~/ 60);
    int timerCaption = (secondToMinute + 1) > widget.timerMinute
        ? secondToMinute
        : (secondToMinute + 1);

    return CustomPaint(
      painter: _MolaCirclePainter(
        timerMinute: widget.timerMinute,
        currentSecond: _seconds,
        isFinished: _isFinished,
        isInOrder: widget.isInOrder,
      ),
      child: Container(
          width: MediaQuery.of(context).size.width * molaRadius,
          height: MediaQuery.of(context).size.width * molaRadius,
          alignment: Alignment.center,
          child: !_isFinished
              ? Text(
                  '$timerCaption',
                  style: timerCircleStyle,
                )
              : Icon(Icons.check_circle, size: 30, color: Color(0xFFFFC700))),
    );
  }
}

class _MolaCirclePainter extends CustomPainter {
  final double _startPoint = 4.71239;
  final double _endPoint = 6.2831;

  final int timerMinute;
  final int currentSecond;
  final bool isFinished;
  final bool isInOrder;

  const _MolaCirclePainter({
    @required this.timerMinute,
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
    _arc(canvas, paint, Colors.grey[400], size, 0, _startPoint, _endPoint);

    // Base circle
    _arc(canvas, paint, Colors.grey[100], size, isInOrder ? 5 : 0, _startPoint,
        _endPoint);

    // Blue progress circle
    _arc(
        canvas,
        paint,
        !isFinished ? Color(0xFF8BC7FF) : Color(0xFFFFC700),
        size,
        isInOrder ? 5 : 0,
        _startPoint,
        (((timerMinute * 60) - currentSecond) / (timerMinute * 60)) *
            _endPoint);

    // Inner circle
    _arc(canvas, paint, Colors.grey[200], size, 20, _startPoint, _endPoint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
