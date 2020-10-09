import 'package:flutter/material.dart';

class ProcessBar extends StatelessWidget {
  final int order;
  final int seT;
  final int tur;
  final int currentTur;
  final String kalanSure;
  final int gecenSure;
  final int toplamSure;
  final int pauseSure;

  const ProcessBar({Key key, this.order = 1, @required this.seT, this.tur = 1, @required this.currentTur, @required this.kalanSure, this.gecenSure = 0, this.pauseSure = 0, @required this.toplamSure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.keyboard_arrow_left,
                          size: 18, color: Colors.black),
                      Text(
                        kalanSure,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          size: 18, color: Colors.black),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.replay, size: 24, color: Colors.black),
                      SizedBox(width: 3),
                      Text(
                        '$currentTur/$tur',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      SizedBox(width: 15),
                      Icon(Icons.settings_ethernet,
                          size: 24, color: Colors.black),
                      SizedBox(width: 3),
                      Text(
                        '$order/$seT',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 10,
            color: Colors.grey[200],
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) =>
                  Container(
                    color: Color(0xFFBCFF93),
                    height: double.infinity,
                    width: ((gecenSure * 100) / toplamSure) * constraints.maxWidth / 100,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) => Container(
                  color: Color(0xFFFF9393),
                  height: double.infinity,
                  width: ((pauseSure * 100) / toplamSure) * constraints.maxWidth / 100,
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
