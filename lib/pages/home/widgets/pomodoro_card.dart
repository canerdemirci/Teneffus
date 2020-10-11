import 'package:flutter/material.dart';

import '../../../Pomodoro.dart';

class PomodoroCard extends StatelessWidget {
  final Pomodoro pomodoro;
  final Function onTap;
  final Function onLongPress;

  const PomodoroCard(
      {Key key,
      @required this.onTap,
      @required this.onLongPress,
      @required this.pomodoro})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildCardProp({int value, IconData icon}) {
      return Column(
        children: [
          Icon(icon),
          Text(
            '$value',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 16,
                ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => onLongPress(pomodoro.id),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8),
        height: 130,
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300], width: 1),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pomodoro.pomodoroAdi,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Toplam: ' +
                  pomodoro.toplamSureToString +
                  ' / Net: ' +
                  pomodoro.netSureToString,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCardProp(icon: Icons.replay, value: pomodoro.tur),
                  buildCardProp(
                      icon: Icons.settings_ethernet, value: pomodoro.seT),
                  buildCardProp(icon: Icons.schedule, value: pomodoro.calisma),
                  buildCardProp(icon: Icons.pause, value: pomodoro.mola),
                  buildCardProp(
                      icon: Icons.lock_open, value: pomodoro.setMolasi),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
