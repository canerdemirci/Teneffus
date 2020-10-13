import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int firstPercent;
  final int secondPercent;
  final Color firstColor;
  final Color secondColor;

  const ProgressBar(
      {Key key,
      @required this.firstPercent,
      @required this.secondPercent,
      @required this.firstColor,
      @required this.secondColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int firstPercentFixed = firstPercent > 100 ? 100 : firstPercent;
    final int secondPercentFixed = secondPercent > 100 ? 100 : secondPercent;

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: 10,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(
                  width: firstPercentFixed * (constraints.maxWidth / 100),
                  decoration: BoxDecoration(
                    color: firstColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.transparent,
          height: 10,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(
                  width: secondPercentFixed * (constraints.maxWidth / 100),
                  decoration: BoxDecoration(
                    color: secondColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
