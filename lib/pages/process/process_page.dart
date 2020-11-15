import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teneffus/Pomodoro.dart';
import 'package:teneffus/pages/process/widgets/break_counter.dart';
import 'package:teneffus/widgets/custom_appbar.dart';

import '../../AppRoutes.dart';
import '../../Counter.dart';
import '../../Responsive.dart';
import '../../constants.dart';
import '../../helper.dart';
import 'widgets/next_timer_indicator.dart';
import 'widgets/process_bar.dart';
import 'widgets/work_counter.dart';

class ProcessPage extends StatefulWidget {
  final Pomodoro pomodoro;

  const ProcessPage({Key key, @required this.pomodoro}) : super(key: key);

  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Timer _timer;
  Animation<double> _animation;
  AnimationController _animationController;
  List<Counter> _counters;
  int _order = 0;
  int _workOrder = 1;
  int _tour = 0;
  bool _isPaused = false;
  int _pauseSecond = 0;
  int _elapsedPomodoroSeconds = 0;
  int _elapsedPausedSeconds = 0;
  DateTime _backgroundTimeStamp;
  DateTime _foregroundTimeStamp;
  int _elapsedBackgroundPauseSeconds = 0;
  int _elapsedBackgroundSeconds = 0;
  double _scrollPosition = 0;
  bool _scroll = false;
  bool _isAppInBack = false;
  double _animPosNum = 0;

  final double _workCounterRadius = .47;
  final double _breakCounterRadius = .28;
  final int _counterMaxFactor = Responsive.mobileMaxWidth;
  final double _nextIndicatorHeight = 108;
  final ScrollController _seqScrollController = ScrollController();

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

  void _nextTour() {
    _scroll = false;
    _order = 0;
    _pauseSecond = 0;
    _workOrder = 1;
    _tour++;
    _initCounters();
    _scrollPosition = 0;
    _seqScrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void _syncCounters(int seconds) {
    for (int i = 0; i < _counters.length; i++) {
      if (seconds > 0) {
        int cs = _counters[i].second;
        _counters[i].second -= seconds;
        if (_counters[i].second < 0) _counters[i].second = 0;
        seconds -= cs;
      } else if (seconds < 0) {
        _counters[i - 1].second = -seconds;
        break;
      }
    }

    if (seconds > 0 && _tour < widget.pomodoro.tour - 1) {
      _nextTour();
      _syncCounters(seconds);
    }
  }

  void _timerOnTick(Timer timer) {
    if (_isAppInBack) return;

    if (!_isPaused)
      setState(() {
        if (_elapsedBackgroundSeconds <= 0) {
          _counters[_order].second--;
          _elapsedPomodoroSeconds++;
        } else {
          _elapsedPomodoroSeconds += _elapsedBackgroundSeconds;
          _syncCounters(_elapsedBackgroundSeconds);
          _elapsedBackgroundSeconds = 0;
        }
      });
    else
      setState(() {
        if (_elapsedBackgroundPauseSeconds <= 0) {
          _pauseSecond++;
          _elapsedPausedSeconds++;
        } else {
          _pauseSecond += _elapsedBackgroundPauseSeconds;
          _elapsedPausedSeconds += _elapsedBackgroundPauseSeconds;
          _elapsedBackgroundPauseSeconds = 0;
        }
        _counters[_order].pauseSecond = _pauseSecond;
      });

    if (_counters[_order].second <= 0) {
      if (_order == _counters.length - 1) {
        if (_tour >= widget.pomodoro.tour - 1)
          _finishProcess();
        else
          setState(() {
            _nextTour();
          });
      } else {
        setState(() {
          _order++;
          if (_counters[_order].type == 0) _workOrder++;
          if (_counters[_order].type == 0) _scroll = true;
          _pauseSecond = 0;
        });
      }
    }
  }

  void _initCounters() {
    _counters = List<Counter>();

    for (int i = 0; i < widget.pomodoro.seT; i++) {
      _counters.add(Counter(
          second: widget.pomodoro.workMinute * 60,
          initialSecond: widget.pomodoro.workMinute * 60,
          pauseSecond: 0,
          type: 0));

      if (i < widget.pomodoro.seT - 1)
        _counters.add(Counter(
            second: widget.pomodoro.breakMinute * 60,
            initialSecond: widget.pomodoro.breakMinute * 60,
            pauseSecond: 0,
            type: 1));
      else if (_tour < widget.pomodoro.tour - 1)
        _counters.add(Counter(
            second: widget.pomodoro.setBreakMinute * 60,
            initialSecond: widget.pomodoro.setBreakMinute * 60,
            pauseSecond: 0,
            type: 1));
    }
  }

  void _finishProcess() {
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.resultPageRoute, arguments: {
      'pomodoro': widget.pomodoro,
      'pauseTime': _elapsedPausedSeconds ~/ 60,
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _backgroundTimeStamp = DateTime.now();
    _foregroundTimeStamp = DateTime.now();
    _initAnimation();
    _initCounters();
    _timer = Timer.periodic(Duration(seconds: 1), _timerOnTick);
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    _animationController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      setState(() {
        _isAppInBack = false;
        _foregroundTimeStamp = DateTime.now();
        if (_isPaused) {
          _elapsedBackgroundSeconds = 0;
          _elapsedBackgroundPauseSeconds = DateTimeRange(
                  start: _foregroundTimeStamp, end: _backgroundTimeStamp)
              .duration
              .inSeconds
              .abs();
        } else {
          _elapsedBackgroundPauseSeconds = 0;
          _elapsedBackgroundSeconds = DateTimeRange(
                  start: _foregroundTimeStamp, end: _backgroundTimeStamp)
              .duration
              .inSeconds
              .abs();
        }
      });
    else
      setState(() {
        _isAppInBack = true;
        _backgroundTimeStamp = DateTime.now();
      });

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    final responsive = Responsive(mediaQueryData: MediaQuery.of(context));

    final pomodoroHeader = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        widget.pomodoro.tour == 1
            ? 'Tek Tur'
            : (_tour == 0 ? 'İlk Tur' : '${_tour + 1}. Tur'),
        style: turHeaderStyle,
      ),
    );

    final pomodoroSequence = Expanded(
      child: SingleChildScrollView(
        controller: _seqScrollController,
        child: Container(
          width: double.infinity,
          child: Column(
            children: _buildSequence(responsive),
          ),
        ),
      ),
    );

    final processBar = ProcessBar(
      seT: widget.pomodoro.seT,
      order: _workOrder,
      tour: widget.pomodoro.tour,
      currentTour: _tour + 1,
      remainingTime: minuteToHourStr(
          widget.pomodoro.totalTime - _elapsedPomodoroSeconds ~/ 60, true),
      elapsedTime: (_elapsedPomodoroSeconds / 60).floor(),
      pauseTime: (_elapsedPausedSeconds / 60).floor(),
      totalTime: widget.pomodoro.totalTime,
    );

    return WillPopScope(
      onWillPop: () async {
        bool result = false;

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Geri Çık'),
            content: Text(
                'Görev tamamlanmadan geri çıkmak istediğinizden emin misiniz?'),
            actions: [
              FlatButton(
                child: Text('EVET'),
                onPressed: () {
                  Navigator.pop(context);
                  result = true;
                },
              ),
              FlatButton(
                child: Text('HAYIR'),
                onPressed: () {
                  Navigator.pop(context);
                  result = false;
                },
              ),
            ],
          ),
        );

        return result;
      },
      child: Scaffold(
        appBar: customAppBar(widget.pomodoro.pomodoroName, false),
        body: Column(
          children: [
            pomodoroHeader,
            pomodoroSequence,
            processBar,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSequence(Responsive responsive) {
    List<Widget> sequence = List<Widget>();

    double workCounterSize = responsive.isMobile
        ? responsive.screenWidth * _workCounterRadius
        : _counterMaxFactor * _workCounterRadius;
    double breakCounterSize = responsive.isMobile
        ? responsive.screenWidth * _breakCounterRadius
        : _counterMaxFactor * _breakCounterRadius;

    for (int i = 0; i < _counters.length; i++) {
      final playIcon = Icon(Icons.play_circle_filled,
          size: workCounterSize / 4.25, color: Color(0xFF464646));
      final breakFinishIcon = Icon(Icons.check_circle,
          size: breakCounterSize / 3.3333, color: Color(0xFFFFC700));
      int efficiencyPercent = (100 -
              ((_counters[i].pauseSecond * 100) ~/
                  (_counters[i].initialSecond)))
          .clamp(0, 100);

      Widget counterResults = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$efficiencyPercent%',
            style:
                counterCircleStyle.copyWith(fontSize: workCounterSize / 7.083),
          ),
          SizedBox(height: workCounterSize / 17),
          Icon(Icons.schedule, size: workCounterSize / 7.083),
          Text(
            (_counters[i].initialSecond ~/ 60).toString(),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: workCounterSize / 12.1428),
          ),
          Icon(Icons.pause, size: workCounterSize / 7.083),
          Text(
            (_counters[i].pauseSecond / 60).toStringAsFixed(2),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: workCounterSize / 12.1428),
          ),
        ],
      );

      final workCounter = GestureDetector(
          onTap: () {
            if (_order == i) setState(() => _isPaused = !_isPaused);
          },
          child: WorkCounter(
            key: Key('$i$_tour' + 'work'),
            size: workCounterSize,
            caption: _counters[i].second <= 0
                ? counterResults
                : (_order == i && _isPaused
                    ? playIcon
                    : Text((_counters[i].second ~/ 60).toString(),
                        style: counterCircleStyle.copyWith(
                            fontSize: workCounterSize / 7.083))),
            shadow: _order == i,
            isPaused: _order == i && _isPaused ? true : false,
            pausePercentage:
                (_counters[i].pauseSecond * 100 ~/ _counters[i].initialSecond)
                    .clamp(0, 100),
            workPercentage:
                100 - (_counters[i].second * 100 ~/ _counters[i].initialSecond),
            anim: _order == i && !_isPaused ? true : false,
            animPos: _animPosNum,
          ));

      final breakCounter = BreakCounter(
        size: breakCounterSize,
        key: Key('$i$_tour' + 'break'),
        caption: _counters[i].second <= 0
            ? breakFinishIcon
            : Text((_counters[i].second ~/ 60).toString(),
                style: counterCircleStyle.copyWith(
                    fontSize: breakCounterSize / 4.1667)),
        percentage:
            100 - (_counters[i].second * 100 ~/ _counters[i].initialSecond),
        shadow: _order == i,
        isFinished: _counters[i].second <= 0,
      );

      if (_counters[i].type == 0)
        sequence.add(workCounter);
      else
        sequence.add(breakCounter);

      if (i < _counters.length - 1) {
        sequence.add(SizedBox(height: 10));
        sequence.add(NextTimerIndicator(work: i.isOdd));
        sequence.add(SizedBox(height: 10));
      }
    }

    if (_scroll) {
      _scrollPosition += responsive.screenWidth * _breakCounterRadius +
          responsive.screenWidth * _workCounterRadius +
          _nextIndicatorHeight * 2;
      _seqScrollController.animateTo(_scrollPosition,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      _scroll = false;
    }

    return sequence;
  }
}
