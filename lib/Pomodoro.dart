import 'package:flutter/foundation.dart';
import 'package:teneffus/helper.dart';

class Pomodoro {
  final String id;
  final String pomodoroName;
  final int tour;
  final int seT;
  final int workMinute;
  final int breakMinute;
  final int setBreakMinute;

  Pomodoro(
      {@required this.id,
      @required this.pomodoroName,
      @required this.tour,
      @required this.seT,
      @required this.workMinute,
      @required this.breakMinute,
      @required this.setBreakMinute});

  Pomodoro.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        pomodoroName = json['pomodoroName'],
        tour = json['tour'],
        seT = json['seT'],
        workMinute = json['workMinute'],
        breakMinute = json['breakMinute'],
        setBreakMinute = json['setBreakMinute'];

  Map<String, dynamic> get toJSON => {
        'id': id,
        'pomodoroName': pomodoroName,
        'tour': tour,
        'seT': seT,
        'workMinute': workMinute,
        'breakMinute': breakMinute,
        'setBreakMinute': setBreakMinute
      };

  int get totalTime =>
      netTime +
      (tour * ((seT - 1) * breakMinute)) +
      ((tour - 1) * setBreakMinute);
  int get netTime => (tour * (seT * workMinute));
  String get totalTimeToString => minuteToHourStr(totalTime);
  String get netTimeToString => minuteToHourStr(netTime);
}
