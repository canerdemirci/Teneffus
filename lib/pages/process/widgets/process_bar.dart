import 'package:flutter/material.dart';

class ProcessBar extends StatelessWidget {
  final int order;
  final int seT;
  final int tour;
  final int currentTour;
  final String remainingTime;
  final int elapsedTime;
  final int totalTime;
  final int pauseTime;

  const ProcessBar(
      {Key key,
      this.order = 1,
      @required this.seT,
      @required this.tour,
      @required this.currentTour,
      @required this.remainingTime,
      this.elapsedTime = 0,
      this.pauseTime = 0,
      @required this.totalTime})
      : super(key: key);

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
                  Text(
                    'Kalan: ' + remainingTime,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 16,
                        ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.replay, size: 24, color: Colors.black),
                      SizedBox(width: 3),
                      Text(
                        '$currentTour/$tour',
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
                  builder: (context, constraints) => Container(
                    color: Color(0xFFBCFF93),
                    height: double.infinity,
                    width: ((elapsedTime * 100) / totalTime) *
                        constraints.maxWidth /
                        100,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) => Container(
                    color: Color(0xFFFF9393),
                    height: double.infinity,
                    width: ((pauseTime * 100) / totalTime) *
                        constraints.maxWidth /
                        100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
