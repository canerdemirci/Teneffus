import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int birinciYuzde;
  final int ikinciYuzde;
  final Color birinciColor;
  final Color ikinciColor;

  const ProgressBar(
      {Key key,
      @required this.birinciYuzde,
      @required this.ikinciYuzde,
      @required this.birinciColor,
      @required this.ikinciColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int birinciYuzdeFixed = birinciYuzde > 100 ? 100 : birinciYuzde;
    final int ikinciYuzdeFixed = ikinciYuzde > 100 ? 100 : ikinciYuzde;

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: 10,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(
                  width: birinciYuzdeFixed * (constraints.maxWidth / 100),
                  decoration: BoxDecoration(
                    color: birinciColor,
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
                  width: ikinciYuzdeFixed * (constraints.maxWidth / 100),
                  decoration: BoxDecoration(
                    color: ikinciColor,
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
