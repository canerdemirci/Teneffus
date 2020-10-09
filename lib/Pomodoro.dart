import 'package:flutter/foundation.dart';

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
  String get netSureToString => netSure % 60 == 0
      ? '${(netSure / 60).floor()}sa'
      : '${(netSure / 60).floor()}sa ${(netSure % 60)}dk';
  int get toplamSure =>
      netSure + (tur * ((seT - 1) * mola)) + ((tur - 1) * setMolasi);
  String get toplamSureToString => toplamSure % 60 == 0
      ? '${(toplamSure / 60).floor()}sa'
      : '${(toplamSure / 60).floor()}sa ${(toplamSure % 60)}dk';
}
