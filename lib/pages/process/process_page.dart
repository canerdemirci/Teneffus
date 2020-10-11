import 'package:flutter/material.dart';
import 'package:teneffus/Pomodoro.dart';
import 'package:teneffus/Responsive.dart';
import 'package:teneffus/helper.dart';
import 'package:teneffus/pages/process/widgets/mola_circle.dart';
import 'package:teneffus/pages/process/widgets/next_timer_indicator.dart';
import 'package:teneffus/pages/process/widgets/timer_circle.dart';
import 'package:teneffus/pages/process/widgets/process_bar.dart';
import 'package:teneffus/widgets/custom_appbar.dart';

import '../../constants.dart';

class ProcessPage extends StatefulWidget {
  final Pomodoro pomodoro;

  const ProcessPage({Key key, @required this.pomodoro}) : super(key: key);

  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  int _order = 0;
  int _molaOrder = -1;
  bool _mola = false;
  int _tur = 1;
  int _gecenSure = 0;
  int _pauseSure = 0;
  double _scroll = 0;
  final ScrollController _seqScrollController = ScrollController();

  void _resetForNextTourOrFinish() {
    if (_tur < widget.pomodoro.tur) {
      _seqScrollController
          .animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.linear)
          .then((_) => setState(() {
                _tur++;
                _scroll = 0;
                _order = 0;
                _molaOrder = -1;
                _mola = false;
              }));
    } else {
      Navigator.pushNamed(context, resultPageRoute, arguments: {
        'pomodoro': widget.pomodoro,
        'pauseSure': _pauseSure ~/ 60,
      });
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
    bool isMobile = Responsive(mediaQueryData: MediaQuery.of(context)).isMobile;

    return Scaffold(
      appBar: customAppBar(widget.pomodoro.pomodoroAdi, false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              widget.pomodoro.tur == 1
                  ? 'Tek Tur'
                  : (_tur == 1 ? 'İlk Tur' : '$_tur. Tur'),
              style: turHeaderStyle,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _seqScrollController,
              child: Container(
                width: double.infinity,
                child: Column(
                  children: _buildSequence(isMobile),
                ),
              ),
            ),
          ),
          ProcessBar(
            seT: widget.pomodoro.seT,
            order: _order + 1,
            tur: widget.pomodoro.tur,
            currentTur: _tur,
            kalanSure: minuteToHourStr(
                widget.pomodoro.toplamSure - _gecenSure ~/ 60, true),
            gecenSure: (_gecenSure / 60).floor(),
            pauseSure: (_pauseSure / 60).floor(),
            toplamSure: widget.pomodoro.toplamSure,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSequence(bool isMobile) {
    List<Widget> sequence = List<Widget>();

    for (int i = 0; i < widget.pomodoro.seT; i++) {
      bool last = i < widget.pomodoro.seT - 1 ? false : true;
      int mola = last ? widget.pomodoro.setMolasi : widget.pomodoro.mola;

      TimerCircle timerCircle = TimerCircle(
        key: Key('0$i$_tur'),
        size: isMobile
            ? MediaQuery.of(context).size.width * timerRadius
            : timerMaxSizeCarpan * timerRadius,
        timerMinute: widget.pomodoro.calisma,
        start: (i == _order && !_mola) ? true : false,
        isInOrder: (i == _order && !_mola) ? true : false,
        onFinished: () {
          setState(() {
            _molaOrder++;
            _mola = true;
          });

          if (last && _tur == widget.pomodoro.tur) _resetForNextTourOrFinish();
        },
        onTick: () {
          setState(() => _gecenSure++);
        },
        onPauseTick: () {
          setState(() => _pauseSure++);
        },
      );
      sequence.add(timerCircle);

      if ((widget.pomodoro.mola > 0 || widget.pomodoro.setMolasi > 0) &&
          !(last && _tur == widget.pomodoro.tur)) {
        sequence.add(SizedBox(height: 10));
        sequence.add(NextTimerIndicator(work: false));
        sequence.add(SizedBox(height: 10));

        sequence.add(MolaCircle(
            key: Key('1$i$_tur'),
            size: isMobile
                ? MediaQuery.of(context).size.width * molaRadius
                : timerMaxSizeCarpan * molaRadius,
            timerMinute: mola,
            start: (i == _molaOrder && _mola) ? true : false,
            isInOrder: (i == _molaOrder && _mola) ? true : false,
            onTick: () {
              setState(() => _gecenSure++);
            },
            onFinished: () {
              setState(() {
                if (_order < widget.pomodoro.seT && !last) _order++;
                _mola = false;
              });

              if (last)
                _resetForNextTourOrFinish();
              else {
                _scroll += MediaQuery.of(context).size.width * molaRadius +
                    MediaQuery.of(context).size.width * timerRadius +
                    nextIndicatorHeight * 2;
                _seqScrollController.animateTo(_scroll,
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
