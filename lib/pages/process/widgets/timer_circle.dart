import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teneffus/constants.dart';

const double startRadians = 4.71239;
const double endRadians = 6.2831;

class TimerCircle extends StatefulWidget {
  final int timerMinute;
  final bool start;
  final bool isInOrder;
  final Function onFinished;
  final Function onTick;
  final Function onPauseTick;

  const TimerCircle({
    Key key,
    @required this.timerMinute,
    this.start = false,
    @required this.isInOrder,
    @required this.onFinished,
    @required this.onTick,
    @required this.onPauseTick,
  }) : super(key: key);

  @override
  _TimerCircleState createState() => _TimerCircleState();
}

class _TimerCircleState extends State<TimerCircle>
    with SingleTickerProviderStateMixin {
  Timer _timer, _pauseTimer;
  int _seconds;
  int _pauseSeconds;
  double _animPosNum;

  Animation<double> _animation;
  AnimationController _animationController;

  bool _isPaused;
  bool _isFinished;

  void _timerCallback(Timer tm) {
    if (!_isPaused && !_isFinished)
      setState(() {
        _seconds--;
        if (!_isFinished) widget.onTick();
        if (_seconds == 0) {
          _isFinished = true;
          widget.onFinished();
          _timer.cancel();
        }
      });
  }

  void _pauseTimerCallback(Timer tm) {
    if (_isPaused && !_isFinished)
      setState(() {
        _pauseSeconds++;
        if (!_isFinished) widget.onPauseTick();
      });
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _animationController.reset();
      else if (status == AnimationStatus.dismissed)
        _animationController.forward();
    });

    _animation =
        Tween(begin: .25, end: endRadians).animate(_animationController)
          ..addListener(() {
            setState(() {
              _animPosNum = _animation.value;
            });
          });
  }

  @override
  void initState() {
    super.initState();

    _seconds = 0;
    _pauseSeconds = 0;
    _animPosNum = 0;
    _isPaused = false;
    _isFinished = false;
    _initAnimation();
    _seconds = widget.timerMinute * 60;
  }

  @override
  void dispose() {
    if (_timer != null && _pauseTimer != null) {
      _timer.cancel();
      _pauseTimer.cancel();
    }

    if (_animationController != null) _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start && _timer == null && _pauseTimer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), _timerCallback);
      _pauseTimer = Timer.periodic(Duration(seconds: 1), _pauseTimerCallback);
    }

    int successRate = 100 - (_pauseSeconds * 100 ~/ (widget.timerMinute * 60));
    int secondToMinute = (_seconds ~/ 60);
    int timerCaption = (secondToMinute + 1) > widget.timerMinute
        ? secondToMinute
        : (secondToMinute + 1);

    if (successRate < 0) successRate = 0;

    return GestureDetector(
      onTap: () {
        if (!_isFinished && widget.start)
          setState(() {
            _isPaused = !_isPaused;
          });
      },
      child: CustomPaint(
        painter: _TimeCirclePainter(
          timerMinute: widget.timerMinute,
          currentSecond: _seconds,
          pauseSecond: _pauseSeconds,
          isPaused: _isPaused,
          isInOrder: widget.isInOrder,
          animPosNum: _animPosNum,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * timerRadius,
          height: MediaQuery.of(context).size.width * timerRadius,
          alignment: Alignment.center,
          child: !_isFinished
              ? (!_isPaused
                  ? Text(
                      '$timerCaption',
                      style: timerCircleStyle,
                    )
                  : Icon(Icons.play_circle_filled,
                      size: 40, color: Color(0xFF464646)))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$successRate%',
                      style: timerCircleStyle,
                    ),
                    SizedBox(height: 10),
                    Icon(Icons.schedule),
                    Text('${widget.timerMinute}',
                        style: Theme.of(context).textTheme.bodyText1),
                    Icon(Icons.pause),
                    Text((_pauseSeconds / 60).toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
        ),
      ),
    );
  }
}

class _TimeCirclePainter extends CustomPainter {
  final int timerMinute;
  final int currentSecond;
  final int pauseSecond;
  final double animPosNum;
  final bool isPaused;
  final bool isInOrder;

  _TimeCirclePainter(
      {@required this.isInOrder,
      @required this.timerMinute,
      @required this.isPaused,
      @required this.currentSecond,
      @required this.pauseSecond,
      @required this.animPosNum});

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
    if (isInOrder)
      _arc(canvas, paint, Colors.grey[400], size, 0, startRadians, endRadians);

    // Base circle
    _arc(canvas, paint, Colors.grey[100], size, isInOrder ? 10 : 0,
        startRadians, endRadians);

    // Green progress circle
    _arc(
        canvas,
        paint,
        !isPaused ? Color(0xFFBCFF93) : Colors.grey[600],
        size,
        isInOrder ? 10 : 0,
        startRadians,
        (((timerMinute * 60) - currentSecond) / (timerMinute * 60)) *
            endRadians);

    // Red progress circle
    var redRate = endRadians * (pauseSecond / (timerMinute * 60));
    _arc(canvas, paint, Color(0xFFFF9393), size, isInOrder ? 10 : 0,
        startRadians, redRate > endRadians ? endRadians : redRate);

    // Inner circle
    _arc(canvas, paint, Colors.grey[200], size, isInOrder ? 25 : 20,
        startRadians, endRadians);

    // Animation circles
    if (isInOrder && !isPaused)
      _arc(canvas, paint, Colors.grey[300], size, isInOrder ? 25 : 20,
          animPosNum, endRadians / 4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
