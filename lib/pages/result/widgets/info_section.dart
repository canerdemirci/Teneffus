import 'package:flutter/material.dart';
import 'package:teneffus/pages/result/widgets/progress_bar.dart';

class InfoSection extends StatelessWidget {
  final ProgressBar progressBar;
  final List<Color> dotColors;
  final List<Color> textColors;
  final List<String> titles;
  final List<String> values;

  const InfoSection(
      {Key key,
      @required this.progressBar,
      @required this.dotColors,
      @required this.textColors,
      @required this.titles,
      @required this.values})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List<Widget>();
    TextStyle textStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
    );

    for (int i = 0; i < titles.length; i++) {
      items.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: dotColors[i],
                ),
                SizedBox(width: 10),
                Text(
                  titles[i],
                  style: textStyle,
                ),
              ],
            ),
            Text(
              values[i],
              style: textStyle.copyWith(color: textColors[i]),
            ),
          ],
        ),
      );

      if (i < titles.length - 1) items.add(SizedBox(height: 10));
    }

    return Column(
      children: [
        progressBar,
        SizedBox(height: 10),
        ...items,
      ],
    );
  }
}
