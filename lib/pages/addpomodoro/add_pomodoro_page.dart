import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teneffus/PomodoroStorage.dart';
import 'package:teneffus/constants.dart';
import 'package:teneffus/widgets/custom_appbar.dart';

import '../../Pomodoro.dart';

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
  final TextEditingController _pmTurController = TextEditingController();
  final TextEditingController _pmSetController = TextEditingController();
  final TextEditingController _pmCalismaController = TextEditingController();
  final TextEditingController _pmMolaController = TextEditingController();
  final TextEditingController _pmSetMolasiController = TextEditingController();

  Pomodoro _pomodoro;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _pomodoro = Pomodoro(
      id: 'id',
      pomodoroAdi: 'Görevim',
      tur: 2,
      seT: 4,
      calisma: 25,
      mola: 5,
      setMolasi: 20,
    );

    _pmAdController.text = _pomodoro.pomodoroAdi;

    _pmTurController
      ..addListener(() {
        int tur = int.tryParse(_pmTurController.text.trim()) ?? 1;
        if (tur < 1) tur = 1;

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroAdi: _pomodoro.pomodoroAdi,
            tur: tur,
            seT: _pomodoro.seT,
            calisma: _pomodoro.calisma,
            mola: _pomodoro.mola,
            setMolasi: _pomodoro.setMolasi,
          ),
        );
      })
      ..text = _pomodoro.tur.toString();

    _pmSetController
      ..addListener(() {
        int seT = int.tryParse(_pmSetController.text.trim()) ?? 1;
        if (seT < 1) seT = 1;

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroAdi: _pomodoro.pomodoroAdi,
            tur: _pomodoro.tur,
            seT: seT,
            calisma: _pomodoro.calisma,
            mola: _pomodoro.mola,
            setMolasi: _pomodoro.setMolasi,
          ),
        );
      })
      ..text = _pomodoro.seT.toString();

    _pmCalismaController
      ..addListener(() {
        int calisma = int.tryParse(_pmCalismaController.text.trim()) ?? 1;
        if (calisma < 1) calisma = 1;

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroAdi: _pomodoro.pomodoroAdi,
            tur: _pomodoro.tur,
            seT: _pomodoro.seT,
            calisma: calisma,
            mola: _pomodoro.mola,
            setMolasi: _pomodoro.setMolasi,
          ),
        );
      })
      ..text = _pomodoro.calisma.toString();

    _pmMolaController
      ..addListener(() {
        int mola = int.tryParse(_pmMolaController.text.trim()) ?? 1;
        if (mola < 1) mola = 1;

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroAdi: _pomodoro.pomodoroAdi,
            tur: _pomodoro.tur,
            seT: _pomodoro.seT,
            calisma: _pomodoro.calisma,
            mola: mola,
            setMolasi: _pomodoro.setMolasi,
          ),
        );
      })
      ..text = _pomodoro.mola.toString();

    _pmSetMolasiController
      ..addListener(() {
        int setMolasi = int.tryParse(_pmSetMolasiController.text.trim()) ?? 1;
        if (setMolasi < 1) setMolasi = 1;

        _pomodoroBarChange(
          Pomodoro(
            id: '_',
            pomodoroAdi: _pomodoro.pomodoroAdi,
            tur: _pomodoro.tur,
            seT: _pomodoro.seT,
            calisma: _pomodoro.calisma,
            mola: _pomodoro.mola,
            setMolasi: setMolasi,
          ),
        );
      })
      ..text = _pomodoro.setMolasi.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
              width: screenSize.width * defaultWidthRatio,
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
                          controller: _pmTurController,
                          icon: Icons.replay,
                          hint: '2',
                          label: 'Tur',
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
                          controller: _pmCalismaController,
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
                                controller: _pmMolaController,
                                icon: Icons.pause,
                                hint: '5',
                                label: 'Mola (dk)',
                              ),
                            ),
                    ],
                  ),
                  _pomodoro.tur < 2
                      ? SizedBox.shrink()
                      : SizedBox(height: appBarBottomMargin),
                  _pomodoro.tur < 2
                      ? SizedBox.shrink()
                      : _FormItem(
                          controller: _pmSetMolasiController,
                          icon: Icons.lock_open,
                          hint: '20',
                          label: 'Set Molası (dk)',
                        ),
                  _pomodoro.tur < 2
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

  void _savePomodoro(BuildContext context) async {
    if (!_emptyControl(controllers: [
      _pmAdController,
      _pmTurController,
      _pmSetController,
      _pmCalismaController,
      _pmMolaController,
      _pmSetMolasiController,
    ])) {
      if (_integerControl(controllers: [
        _pmTurController,
        _pmSetController,
        _pmCalismaController,
        _pmMolaController,
        _pmSetMolasiController,
      ])) {
        int tur = int.parse(_pmTurController.text.trim());
        int seT = int.parse(_pmSetController.text.trim());
        int calisma = int.parse(_pmCalismaController.text.trim());
        int mola = int.parse(_pmMolaController.text.trim());
        int setMolasi = int.parse(_pmSetMolasiController.text.trim());
        String pomodoroAdi = _pmAdController.text.trim();

        Pomodoro pmd = Pomodoro(
          id: DateTime.now().toString(),
          pomodoroAdi: pomodoroAdi
              .split(' ')
              .map((str) => str[0].toUpperCase() + str.substring(1))
              .join(' '),
          tur: tur < 1 ? 1 : tur,
          seT: seT < 1 ? 1 : seT,
          calisma: calisma < 1 ? 1 : calisma,
          mola: seT < 2 ? mola = 0 : (mola < 1 ? 1 : mola),
          setMolasi: tur < 2 ? setMolasi = 0 : (setMolasi < 1 ? 1 : setMolasi),
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
              pomodoro.netSureToString,
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
                width: (pomodoro.netSure / pomodoro.toplamSure) *
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
              pomodoro.toplamSureToString,
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
