import 'package:flutter/material.dart';

class NextTimerIndicator extends StatelessWidget {
  final bool work;

  const NextTimerIndicator({Key key, @required this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final downArrows = List<Widget>.generate(3, (index) => Icon(Icons.expand_more, size: 22, color: Color(0xFFCCC9C9)));

    return Column(
      children: [
        ...downArrows,
        Icon(work ? Icons.schedule : Icons.pause, size: 22, color: Color(0xFFCCC9C9)),
      ],
    );
  }
}