import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teneffus/PomodoroStorage.dart';
import 'package:teneffus/constants.dart';
import 'package:teneffus/widgets/custom_appbar.dart';

import '../../Pomodoro.dart';
import '../../Responsive.dart';

class AddPomodoroPage extends StatefulWidget {
  final List<Pomodoro> pomodoroList;

  const AddPomodoroPage({Key key, @required this.pomodoroList})
      : super(key: key);

  @override
  _AddPomodoroPageState createState() => _AddPomodoroPageState();
}

class _AddPomodoroPageState extends State<AddPomodoroPage> {
  final PomodoroStorage _pomodoroStorage = PomodoroStorage();

  final TextEditingController _pmAdController = TextEditingController();
  final TextEditingController _pmTourController = TextEditingController();
  final TextEditingController _pmSetController = TextEditingController();
  final TextEditingController _pmWorkController = TextEditingController();
  final TextEditingController _pmBreakController = TextEditingController();
  final TextEditingController _pmSetBreakController = TextEditingController();

  Pomodoro _pomodoro;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _pomodoro = Pomodoro(
      id: 'id',
      pomodoroName: 'Görevim',
      tour: 2,
      seT: 4,
      workMinute: 25,
      breakMinute: 5,
      setBreakMinute: 20,
    );

    _pmAdController.text = _pomodoro.pomodoroName;

    _pmTourController
      ..addListener(() {
        int tour = int.tryParse(_pmTourController.text.trim()) ?? 1;
        if (tour < 1) {
          tour = 1;
          _pmTourController.text = '1';
        }

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroName: _pomodoro.pomodoroName,
            tour: tour,
            seT: _pomodoro.seT,
            workMinute: _pomodoro.workMinute,
            breakMinute: _pomodoro.breakMinute,
            setBreakMinute: _pomodoro.setBreakMinute,
          ),
        );
      })
      ..text = _pomodoro.tour.toString();

    _pmSetController
      ..addListener(() {
        int seT = int.tryParse(_pmSetController.text.trim()) ?? 1;
        if (seT < 1) {
          seT = 1;
          _pmSetController.text = '1';
        }

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroName: _pomodoro.pomodoroName,
            tour: _pomodoro.tour,
            seT: seT,
            workMinute: _pomodoro.workMinute,
            breakMinute: _pomodoro.breakMinute,
            setBreakMinute: _pomodoro.setBreakMinute,
          ),
        );
      })
      ..text = _pomodoro.seT.toString();

    _pmWorkController
      ..addListener(() {
        int workMinute = int.tryParse(_pmWorkController.text.trim()) ?? 1;
        if (workMinute < 1) {
          workMinute = 1;
          _pmWorkController.text = '1';
        }

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroName: _pomodoro.pomodoroName,
            tour: _pomodoro.tour,
            seT: _pomodoro.seT,
            workMinute: workMinute,
            breakMinute: _pomodoro.breakMinute,
            setBreakMinute: _pomodoro.setBreakMinute,
          ),
        );
      })
      ..text = _pomodoro.workMinute.toString();

    _pmBreakController
      ..addListener(() {
        int breakMinute = int.tryParse(_pmBreakController.text.trim()) ?? 1;
        if (breakMinute < 1) {
          breakMinute = 1;
          _pmBreakController.text = '1';
        }

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroName: _pomodoro.pomodoroName,
            tour: _pomodoro.tour,
            seT: _pomodoro.seT,
            workMinute: _pomodoro.workMinute,
            breakMinute: breakMinute,
            setBreakMinute: _pomodoro.setBreakMinute,
          ),
        );
      })
      ..text = _pomodoro.breakMinute.toString();

    _pmSetBreakController
      ..addListener(() {
        int setBreakMinute =
            int.tryParse(_pmSetBreakController.text.trim()) ?? 1;
        if (setBreakMinute < 1) {
          setBreakMinute = 1;
          _pmSetBreakController.text = '1';
        }

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroName: _pomodoro.pomodoroName,
            tour: _pomodoro.tour,
            seT: _pomodoro.seT,
            workMinute: _pomodoro.workMinute,
            breakMinute: _pomodoro.breakMinute,
            setBreakMinute: setBreakMinute,
          ),
        );
      })
      ..text = _pomodoro.setBreakMinute.toString();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(mediaQueryData: MediaQuery.of(context));

    var addButton = SizedBox(
      width: double.infinity,
      child: FlatButton(
        onPressed: () async => _savePomodoro(context),
        color: Colors.grey[900],
        child: Text(
          'EKLE',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar(appTitle, true),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: SizedBox(
              width: responsive.screenWidth * defaultWidthRatio,
              child: Column(
                children: [
                  SizedBox(height: appBarBottomMargin),
                  _PomodoroLengthBar(pomodoro: _pomodoro),
                  SizedBox(height: appBarBottomMargin + 10),
                  _FormItem(
                    controller: _pmAdController,
                    icon: Icons.star,
                    hint: 'Görev Adı',
                    label: 'Görev Adı',
                    isNumber: false,
                  ),
                  SizedBox(height: appBarBottomMargin),
                  Row(
                    children: [
                      Expanded(
                        child: _FormItem(
                          controller: _pmTourController,
                          icon: Icons.replay,
                          hint: '2',
                          label: 'tour',
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _FormItem(
                          controller: _pmSetController,
                          icon: Icons.settings_ethernet,
                          hint: '4',
                          label: 'Set',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: appBarBottomMargin),
                  Row(
                    children: [
                      Expanded(
                        child: _FormItem(
                          controller: _pmWorkController,
                          icon: Icons.schedule,
                          hint: '25',
                          label: 'Çalışma (dk)',
                        ),
                      ),
                      _pomodoro.seT < 2
                          ? SizedBox.shrink()
                          : SizedBox(width: 20),
                      _pomodoro.seT < 2
                          ? SizedBox.shrink()
                          : Expanded(
                              child: _FormItem(
                                controller: _pmBreakController,
                                icon: Icons.pause,
                                hint: '5',
                                label: 'Mola (dk)',
                              ),
                            ),
                    ],
                  ),
                  _pomodoro.tour < 2
                      ? SizedBox.shrink()
                      : SizedBox(height: appBarBottomMargin),
                  _pomodoro.tour < 2
                      ? SizedBox.shrink()
                      : _FormItem(
                          controller: _pmSetBreakController,
                          icon: Icons.lock_open,
                          hint: '20',
                          label: 'Set Molası (dk)',
                        ),
                  _pomodoro.tour < 2
                      ? SizedBox.shrink()
                      : SizedBox(height: appBarBottomMargin),
                  addButton,
                  SizedBox(height: appBarBottomMargin),
                  Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.red),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  bool _emptyControl(
      {List<TextEditingController> controllers,
      String message = 'Form alanları boş bırakılamaz.'}) {
    for (var controller in controllers) {
      String value = controller.text.trim();

      if (value.isEmpty) {
        setState(() => _errorMessage = message);

        return true;
      }
    }

    return false;
  }

  bool _integerControl(
      {List<TextEditingController> controllers,
      String message = 'Sayı alanlarına sadece sayı girilebilir.'}) {
    for (var controller in controllers) {
      String value = controller.text.trim();

      if (int.tryParse(value) == null) {
        setState(() => _errorMessage = message);

        return false;
      }
    }

    return true;
  }

  bool formControl() {
    if (!_emptyControl(controllers: [
      _pmAdController,
      _pmTourController,
      _pmSetController,
      _pmWorkController,
      _pmBreakController,
      _pmSetBreakController,
    ])) {
      if (_integerControl(controllers: [
        _pmTourController,
        _pmSetController,
        _pmWorkController,
        _pmBreakController,
        _pmSetBreakController,
      ])) {
        return true;
      }
    }

    return false;
  }

  void _savePomodoro(BuildContext context) async {
    if (formControl()) {
      int tour = int.parse(_pmTourController.text.trim()).clamp(1, 99);
      int seT = int.parse(_pmSetController.text.trim()).clamp(1, 20);
      int workMinute = int.parse(_pmWorkController.text.trim()).clamp(1, 480);
      int breakMinute = int.parse(_pmBreakController.text.trim()).clamp(1, 60);
      int setBreakMinute =
          int.parse(_pmSetBreakController.text.trim()).clamp(1, 120);
      String pomodoroName = _pmAdController.text.trim();

      Pomodoro pmd = Pomodoro(
        id: DateTime.now().toString(),
        pomodoroName: pomodoroName
            .split(' ')
            .map((str) => str[0].toUpperCase() + str.substring(1))
            .join(' '),
        tour: tour,
        seT: seT,
        workMinute: workMinute,
        breakMinute: seT < 2 ? breakMinute = 0 : breakMinute,
        setBreakMinute: tour < 2 ? setBreakMinute = 0 : setBreakMinute,
      );

      widget.pomodoroList.add(pmd);

      List<Map> pmMaps = List<Map>();
      widget.pomodoroList.forEach((p) => pmMaps.add(p.toJSON));

      try {
        await _pomodoroStorage.writeData(jsonEncode(pmMaps));
        setState(() => _errorMessage = '');
        Navigator.pop(context);
      } catch (error) {
        setState(() => _errorMessage = 'Bir hata oluştu!');
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
      }
    }
  }

  void _pomodoroBarChange(Pomodoro pomodoro) {
    setState(() => _pomodoro = pomodoro);
  }
}

class _FormItem extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isNumber;
  final TextEditingController controller;

  const _FormItem(
      {Key key,
      @required this.controller,
      this.isNumber = true,
      @required this.icon,
      this.label,
      @required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLength: !isNumber ? 150 : 3,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: label,
        counter: SizedBox.shrink(),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _PomodoroLengthBar extends StatelessWidget {
  final Pomodoro pomodoro;

  const _PomodoroLengthBar({Key key, @required this.pomodoro})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              pomodoro.netTimeToString,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.grey[900],
                  ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: constraints.maxHeight,
                width: (pomodoro.netTime / pomodoro.totalTime) *
                    constraints.maxWidth,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              pomodoro.totalTimeToString,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
