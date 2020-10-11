import 'package:flutter/foundation.dart';
import 'package:teneffus/helper.dart';

class Pomodoro {
  final String id;
  final String pomodoroAdi;
  final int tur;
  final int seT;
  final int calisma;
  final int mola;
  final int setMolasi;

  Pomodoro(
      {@required this.id,
      @required this.pomodoroAdi,
      @required this.tur,
      @required this.seT,
      @required this.calisma,
      @required this.mola,
      @required this.setMolasi});

  Pomodoro.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        pomodoroAdi = json['pomodoroAdi'],
        tur = json['tur'],
        seT = json['seT'],
        calisma = json['calisma'],
        mola = json['mola'],
        setMolasi = json['setMolasi'];

  Map<String, dynamic> get toJSON => {
        'id': id,
        'pomodoroAdi': pomodoroAdi,
        'tur': tur,
        'seT': seT,
        'calisma': calisma,
        'mola': mola,
        'setMolasi': setMolasi
      };

  int get netSure => (tur * (seT * calisma));
  String get netSureToString => minuteToHourStr(netSure);
  int get toplamSure =>
      netSure + (tur * ((seT - 1) * mola)) + ((tur - 1) * setMolasi);
  String get toplamSureToString => minuteToHourStr(toplamSure);
}
