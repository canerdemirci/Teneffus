import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teneffus/helper.dart';
import 'package:teneffus/pages/result/widgets/info_section.dart';
import 'package:teneffus/pages/result/widgets/progress_bar.dart';

class ResultPage extends StatelessWidget {
  final Map data;

  const ResultPage({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    int workTime = data['pomodoro'].netTime;
    int breakTime = data['pomodoro'].totalTime - data['pomodoro'].netTime;
    int taskTime = data['pomodoro'].totalTime;
    int effiencyPercent = 100 - ((data['pauseTime'] * 100) ~/ workTime);
    String workTimeStr = minuteToHourStr(workTime);
    String breakTimeStr = minuteToHourStr(breakTime);
    String taskTimeStr = minuteToHourStr(taskTime);
    String pauseTimeStr = minuteToHourStr(data['pauseTime'], true);

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
                              text: '$effiencyPercent%',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      InfoSection(
                          progressBar: ProgressBar(
                            firstColor: Color(0xFFFF9393),
                            secondColor: Color(0xFFBCFF93),
                            firstPercent: 100 - effiencyPercent,
                            secondPercent: effiencyPercent,
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
                            workTimeStr,
                            pauseTimeStr
                          ]),
                      SizedBox(height: 20),
                      InfoSection(
                          progressBar: ProgressBar(
                            firstColor: Color(0xFFBCFF93),
                            secondColor: Color(0xFF8BC7FF),
                            firstPercent:
                                (100 * workTime) ~/ data['pomodoro'].totalTime,
                            secondPercent: breakTime == 0
                                ? 0
                                : (100 * breakTime) ~/
                                    data['pomodoro'].totalTime,
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
                            taskTimeStr,
                            workTimeStr,
                            breakTimeStr
                          ])
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.reply, color: Colors.black),
                    iconSize: 42,
                    onPressed: () {
                      Navigator.pop(context);
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
