import 'package:flutter/material.dart';
import 'package:teneffus/widgets/custom_appbar.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('SONUÇLAR', false),
      body: Center(
        child: Text('hello'),
      ),
    );
  }
}
