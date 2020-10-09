import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teneffus/constants.dart';
import './widgets/pomodoro_card.dart';
import 'package:teneffus/pages/home/widgets/add_button.dart';
import 'package:teneffus/widgets/custom_appbar.dart';
import 'package:teneffus/Pomodoro.dart';

import '../../PomodoroStorage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loadingData = true;
  bool _fatalError = false;

  final PomodoroStorage _pomodoroStorage = PomodoroStorage();
  final List<Pomodoro> _pomodoroList = List<Pomodoro>();

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final addButton = SizedBox(
        width: screenSize.width * defaultWidthRatio,
        child: AddButton(
          onPressed: () async {
            await Navigator.pushNamed(context, addPomodoroPageRoute,
                arguments: _pomodoroList);
            setState(() {});
          },
        ));

    final emptyStartWidget = Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Positioned(
          top: appBarBottomMargin,
          child: addButton,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/relax.svg',
              width: 101,
              height: 101,
            ),
            SizedBox(height: 10),
            Text(
              'Verimli bir çalışmaya\nhazır mısınız?',
              textAlign: TextAlign.center,
              style: startReadyTextStyle,
            ),
          ],
        ),
      ],
    );

    final body = SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: appBarBottomMargin),
            addButton,
            SizedBox(height: appBarBottomMargin),
            Wrap(
              alignment: _pomodoroList.length == 1
                  ? WrapAlignment.start
                  : WrapAlignment.center,
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 20,
              children: _generatePomodoroList(),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar(appTitle, true),
      body: _loadingData
          ? Center(child: CircularProgressIndicator())
          : (_fatalError
              ? Center(
                  child: Text(
                      'Bir hata oluştu! Uygulamayı tekrar açmayı deneyin.'))
              : (_pomodoroList.isEmpty ? emptyStartWidget : body)),
    );
  }

  List<Widget> _generatePomodoroList() => _pomodoroList
      .map((p) => PomodoroCard(
          pomodoro: p,
          onTap: () =>
              Navigator.pushNamed(context, processPageRoute, arguments: p),
          onLongPress: (id) => _deletePomodoro(id: id)))
      .toList()
      .reversed
      .toList();

  void _fetchData() async {
    final String data = await _pomodoroStorage.readData();

    if (data != null) {
      try {
        List dt = jsonDecode(data);
        dt.forEach((pm) => _pomodoroList.add(Pomodoro.fromJSON(pm)));
      } on FormatException catch (error) {
        print(error.message);
      }
    } else
      setState(() => _fatalError = true);

    setState(() => _loadingData = false);
  }

  void _deletePomodoro({String id}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Görevi Sil'),
        content: Text('Bu görevi silmek istediğinizden emin misiniz?'),
        actions: [
          FlatButton(
              child: Text('EVET'),
              onPressed: () async {
                _pomodoroList.removeWhere((p) => p.id == id);

                if (_pomodoroList.length > 0) {
                  List<Map> pmMaps = List<Map>();
                  _pomodoroList.forEach((p) => pmMaps.add(p.toJSON));
                  await _pomodoroStorage.writeData(jsonEncode(pmMaps));
                } else {
                  await _pomodoroStorage.writeData('');
                }

                setState(() {});

                Navigator.pop(context);
              }),
          FlatButton(
            child: Text('HAYIR'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
