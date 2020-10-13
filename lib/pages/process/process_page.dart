import 'package:flutter/material.dart';
import 'package:teneffus/Pomodoro.dart';
import 'package:teneffus/Responsive.dart';
import 'package:teneffus/helper.dart';
import 'package:teneffus/pages/process/widgets/break_counter.dart';
import 'package:teneffus/pages/process/widgets/next_timer_indicator.dart';
import 'package:teneffus/pages/process/widgets/work_counter.dart';
import 'package:teneffus/pages/process/widgets/process_bar.dart';
import 'package:teneffus/widgets/custom_appbar.dart';

import '../../AppRoutes.dart';
import '../../constants.dart';

class ProcessPage extends StatefulWidget {
  final Pomodoro pomodoro;

  const ProcessPage({Key key, @required this.pomodoro}) : super(key: key);

  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  int _workOrder = 0;
  int _breakOrder = -1;
  int _tour = 1;
  int _elapsedTime = 0;
  int _pauseTime = 0;
  bool _break = false;
  double _scrollPosition = 0;

  final ScrollController _seqScrollController = ScrollController();

  final double _workCounterRadius = .47;
  final double _breakCounterRadius = .28;
  final int _counterMaxFactor = Responsive.mobileMaxWidth;
  final double _nextIndicatorHeight = 108;

  void _resetForNextTour() {
    _seqScrollController
        .animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.linear)
        .then((_) => setState(() {
              _tour++;
              _scrollPosition = 0;
              _workOrder = 0;
              _breakOrder = -1;
              _break = false;
            }));
  }

  void _finishProcess() {
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.resultPageRoute, arguments: {
      'pomodoro': widget.pomodoro,
      'pauseTime': _pauseTime ~/ 60,
    });
  }

  void _resetForNextTourOrFinish() {
    if (_tour < widget.pomodoro.tour) {
      _resetForNextTour();
    } else {
      _finishProcess();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(mediaQueryData: MediaQuery.of(context));

    final pomodoroHeader = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        widget.pomodoro.tour == 1
            ? 'Tek Tur'
            : (_tour == 1 ? 'İlk Tur' : '$_tour. Tur'),
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
      order: _workOrder + 1,
      tour: widget.pomodoro.tour,
      currentTour: _tour,
      remainingTime:
          minuteToHourStr(widget.pomodoro.totalTime - _elapsedTime ~/ 60, true),
      elapsedTime: (_elapsedTime / 60).floor(),
      pauseTime: (_pauseTime / 60).floor(),
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

    for (int i = 0; i < widget.pomodoro.seT; i++) {
      bool last = i < widget.pomodoro.seT - 1 ? false : true;
      int mola =
          last ? widget.pomodoro.setBreakMinute : widget.pomodoro.breakMinute;

      WorkCounter timerCircle = WorkCounter(
        key: Key('0$i$_tour'),
        countDownMinute: widget.pomodoro.workMinute,
        size: responsive.isMobile
            ? responsive.screenWidth * _workCounterRadius
            : _counterMaxFactor * _workCounterRadius,
        start: (i == _workOrder && !_break) ? true : false,
        isInOrder: (i == _workOrder && !_break) ? true : false,
        onFinished: () {
          setState(() {
            _breakOrder++;
            _break = true;
          });

          if (last && _tour == widget.pomodoro.tour)
            _resetForNextTourOrFinish();
        },
        onTick: () {
          setState(() => _elapsedTime++);
        },
        onPauseTick: () {
          setState(() => _pauseTime++);
        },
      );
      sequence.add(timerCircle);

      if ((widget.pomodoro.breakMinute > 0 ||
              widget.pomodoro.setBreakMinute > 0) &&
          !(last && _tour == widget.pomodoro.tour)) {
        sequence.add(SizedBox(height: 10));
        sequence.add(NextTimerIndicator(work: false));
        sequence.add(SizedBox(height: 10));

        sequence.add(BreakCounter(
            key: Key('1$i$_tour'),
            size: responsive.isMobile
                ? responsive.screenWidth * _breakCounterRadius
                : _counterMaxFactor * _breakCounterRadius,
            countDownMinute: mola,
            start: (i == _breakOrder && _break) ? true : false,
            isInOrder: (i == _breakOrder && _break) ? true : false,
            onTick: () {
              setState(() => _elapsedTime++);
            },
            onFinished: () {
              setState(() {
                if (_workOrder < widget.pomodoro.seT && !last) _workOrder++;
                _break = false;
              });

              if (last)
                _resetForNextTourOrFinish();
              else {
                _scrollPosition +=
                    responsive.screenWidth * _breakCounterRadius +
                        responsive.screenWidth * _workCounterRadius +
                        _nextIndicatorHeight * 2;
                _seqScrollController.animateTo(_scrollPosition,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
              }
            }));
        sequence.add(SizedBox(height: 10));
      }

      if (!last) {
        sequence.add(NextTimerIndicator(work: true));
        sequence.add(SizedBox(height: 10));
      }

      if (last) sequence.add(SizedBox(height: 40));
    }

    return sequence;
  }
}
