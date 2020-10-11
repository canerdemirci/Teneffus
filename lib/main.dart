import 'package:flutter/material.dart';
import 'package:teneffus/constants.dart';
import 'package:teneffus/pages/addpomodoro/add_pomodoro_page.dart';
import 'package:teneffus/pages/home/home_page.dart';
import 'package:flutter/services.dart';
import 'package:teneffus/pages/process/process_page.dart';
import 'package:teneffus/pages/result/result_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teneffüs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme.of(context).copyWith(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyText1: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              bodyText2: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFFAAAAAA),
              ),
            ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Color(0xFF565656),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => HomePage(),
        addPomodoroPageRoute: (context) => AddPomodoroPage(
            pomodoroList: ModalRoute.of(context).settings.arguments),
        processPageRoute: (context) =>
            ProcessPage(pomodoro: ModalRoute.of(context).settings.arguments),
        resultPageRoute: (context) =>
            ResultPage(data: ModalRoute.of(context).settings.arguments),
      },
    );
  }
}
