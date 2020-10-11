import 'package:flutter/material.dart';
import 'package:teneffus/helper.dart';
import 'package:teneffus/pages/result/widgets/info_section.dart';
import 'package:teneffus/pages/result/widgets/progress_bar.dart';

class ResultPage extends StatelessWidget {
  final Map data;

  const ResultPage({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int calismaSuresi = data['pomodoro'].netSure;
    int molaSuresi = data['pomodoro'].toplamSure - data['pomodoro'].netSure;
    int gorevSuresi = data['pomodoro'].toplamSure;
    int verimlilikYuzdesi = 100 - ((data['pauseSure'] * 100) ~/ calismaSuresi);
    String calismaSuresiStr = minuteToHourStr(calismaSuresi);
    String molaSuresiStr = minuteToHourStr(molaSuresi);
    String gorevSuresiStr = minuteToHourStr(gorevSuresi);
    String pauseSureStr = minuteToHourStr(data['pauseSure'], true);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 425),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Column(
                    children: [
                      Icon(Icons.check, size: 72, color: Colors.blueAccent),
                      SizedBox(height: 20),
                      Text(
                        'Tebrikler!\nÇalışmanızı Bitirdiniz.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'Verimlilik: ',
                            ),
                            TextSpan(
                              text: '$verimlilikYuzdesi%',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      InfoSection(
                          progressBar: ProgressBar(
                            birinciColor: Color(0xFFFF9393),
                            ikinciColor: Color(0xFFBCFF93),
                            birinciYuzde: 100 - verimlilikYuzdesi,
                            ikinciYuzde: verimlilikYuzdesi,
                          ),
                          dotColors: [
                            Color(0xFFBCFF93),
                            Color(0xFFFF9393)
                          ],
                          textColors: [
                            Color(0xFF408317),
                            Colors.red
                          ],
                          titles: [
                            'Toplam Çalışma Süresi',
                            'Toplam Duraklatma Süresi'
                          ],
                          values: [
                            calismaSuresiStr,
                            pauseSureStr
                          ]),
                      SizedBox(height: 20),
                      InfoSection(
                          progressBar: ProgressBar(
                            birinciColor: Color(0xFFBCFF93),
                            ikinciColor: Color(0xFF8BC7FF),
                            birinciYuzde: (100 * calismaSuresi) ~/
                                data['pomodoro'].toplamSure,
                            ikinciYuzde: molaSuresi == 0
                                ? 0
                                : (100 * molaSuresi) ~/
                                    data['pomodoro'].toplamSure,
                          ),
                          dotColors: [
                            Color(0xFFCCC9C9),
                            Color(0xFFBCFF93),
                            Color(0xFF8BC7FF)
                          ],
                          textColors: [
                            Colors.red,
                            Color(0xFF408317),
                            Color(0xFF03579C)
                          ],
                          titles: [
                            'Görev Süresi',
                            'Görev Çalışma Süresi',
                            'Görev Mola Süresi'
                          ],
                          values: [
                            gorevSuresiStr,
                            calismaSuresiStr,
                            molaSuresiStr
                          ])
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.reply, color: Colors.black),
                    iconSize: 42,
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
