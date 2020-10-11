import 'package:flutter/material.dart';

final double startRadians = 4.71239;
final double endRadians = 6.29;

final double timerRadius = .47;
final double molaRadius = .28;
final int timerMaxSizeCarpan = 425;
final double nextIndicatorHeight = 108;

final String appTitle = 'TENEFFÜS';

final TextStyle appMainTitleStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: Colors.black,
  letterSpacing: 8,
);

final TextStyle turHeaderStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 24,
  color: Colors.grey[900],
  fontWeight: FontWeight.bold,
);

final TextStyle appTitleStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

final String addPomodoroPageRoute = '/addpomodoro';
final String processPageRoute = '/process';
final String resultPageRoute = '/result';

final double appBarBottomMargin = 20;
final double defaultWidthRatio = .85;

final TextStyle startReadyTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 24,
  color: Color(0xFFCCC9C9),
);

final TextStyle timerCircleStyle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
  color: Color(0xFF565656),
);

class StringAsset {
  bool turkish;

  StringAsset({@required this.turkish});

  String get verimliCalisma => turkish
      ? 'Verimli bir çalışmaya\nhazır mısınız?'
      : 'Are you ready\nan effective working?';
}
