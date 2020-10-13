import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teneffus/constants.dart';

class WorkCounter extends StatefulWidget {
  final int countDownMinute;
  final double size;
  final bool start;
  final bool isInOrder;
  final Function onFinished;
  final Function onTick;
  final Function onPauseTick;

  const WorkCounter({
    Key key,
    @required this.countDownMinute,
    @required this.size,
    this.start = false,
    @required this.isInOrder,
    @required this.onFinished,
    @required this.onTick,
    @required this.onPauseTick,
  }) : super(key: key);

  @override
  _WorkCounterState createState() => _WorkCounterState();
}

class _WorkCounterState extends State<WorkCounter>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Timer _workTimer, _pauseTimer;
  Animation<double> _animation;
  AnimationController _animationController;
  int _seconds;
  int _pauseSeconds;
  double _animPosNum;
  bool _isPaused;
  bool _isFinished;

  void _finish() {
    _isFinished = true;
    widget.onFinished();
    _workTimer.cancel();
    _pauseTimer.cancel();
  }

  void _workOnTick(Timer tm) {
    if (!_isPaused && !_isFinished)
      setState(() {
        _seconds--;
        widget.onTick();
        if (_seconds <= 0) _finish();
      });
  }

  void _pauseOnTick(Timer tm) {
    if (_isPaused && !_isFinished)
      setState(() {
        _pauseSeconds++;
        widget.onPauseTick();
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

  void _initCounter() {
    _pauseSeconds = 0;
    _animPosNum = 0;
    _isPaused = false;
    _isFinished = false;
    _seconds = widget.countDownMinute * 60;
    _initAnimation();
  }

  void _initTimers() {
    if (widget.start && _workTimer == null && _pauseTimer == null) {
      _workTimer = Timer.periodic(Duration(seconds: 1), _workOnTick);
      _pauseTimer = Timer.periodic(Duration(seconds: 1), _pauseOnTick);
    }
  }

  void _onTap() {
    if (!_isFinished && widget.start)
      setState(() {
        _isPaused = !_isPaused;
      });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        setState(() {});
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initCounter();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (_workTimer != null && _pauseTimer != null) {
      _workTimer.cancel();
      _pauseTimer.cancel();
    }

    if (_animationController != null) _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initTimers();

    int efficiencyPercent =
        (100 - ((_pauseSeconds * 100) ~/ (widget.countDownMinute * 60)))
            .clamp(0, 100);
    int secondToMinute = (_seconds ~/ 60);
    int counterCaption = (secondToMinute + 1) > widget.countDownMinute
        ? secondToMinute
        : (secondToMinute + 1);

    Widget counterCaptionText = Text(
      '$counterCaption',
      style: timerCircleStyle.copyWith(fontSize: widget.size / 7.083),
    );

    Widget counterCaptionIcon = Icon(Icons.play_circle_filled,
        size: widget.size / 4.25, color: Color(0xFF464646));

    Widget counterResults = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$efficiencyPercent%',
          style: timerCircleStyle.copyWith(fontSize: widget.size / 7.083),
        ),
        SizedBox(height: widget.size / 17),
        Icon(Icons.schedule, size: widget.size / 7.083),
        Text(
          '${widget.countDownMinute}',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontSize: widget.size / 12.1428),
        ),
        Icon(Icons.pause, size: widget.size / 7.083),
        Text(
          (_pauseSeconds / 60).toStringAsFixed(2),
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontSize: widget.size / 12.1428),
        ),
      ],
    );

    return GestureDetector(
      onTap: _onTap,
      child: CustomPaint(
        painter: _TimrCounterPainter(
          countDownMinute: widget.countDownMinute,
          currentSecond: _seconds,
          pauseSecond: _pauseSeconds,
          isPaused: _isPaused,
          isInOrder: widget.isInOrder,
          animPosNum: _animPosNum,
        ),
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          child: !_isFinished
              ? (!_isPaused ? counterCaptionText : counterCaptionIcon)
              : counterResults,
        ),
      ),
    );
  }
}

class _TimrCounterPainter extends CustomPainter {
  final int countDownMinute;
  final int currentSecond;
  final int pauseSecond;
  final double animPosNum;
  final bool isPaused;
  final bool isInOrder;

  _TimrCounterPainter(
      {@required this.isInOrder,
      @required this.countDownMinute,
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
        (((countDownMinute * 60) - currentSecond) / (countDownMinute * 60)) *
            endRadians);

    // Red progress circle
    var redRate = endRadians * (pauseSecond / (countDownMinute * 60));
    _arc(canvas, paint, Color(0xFFFF9393), size, isInOrder ? 10 : 0,
        startRadians, redRate > endRadians ? endRadians : redRate);

    // Inner circle
    _arc(canvas, paint, Colors.grey[200], size, isInOrder ? 30 : 25,
        startRadians, endRadians);

    // Animation circles
    if (isInOrder && !isPaused)
      _arc(canvas, paint, Colors.grey[300], size, isInOrder ? 30 : 25,
          animPosNum, endRadians / 4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
