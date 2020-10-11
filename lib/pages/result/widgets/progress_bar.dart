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
    return Container(
      color: Colors.transparent,
      height: 10,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Container(
              width: birinciYuzde > ikinciYuzde
                  ? birinciYuzde * (constraints.maxWidth / 100)
                  : ikinciYuzde * (constraints.maxWidth / 100),
              decoration: BoxDecoration(
                color: ikinciColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: ikinciYuzde < birinciYuzde
                  ? ikinciYuzde * (constraints.maxWidth / 100)
                  : birinciYuzde * (constraints.maxWidth / 100),
              decoration: BoxDecoration(
                color: ikinciColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
