import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PomodoroStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/data.txt');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      String content;

      if (await file.exists() == false) await file.create();
      if (await file.exists() == true) content = await file.readAsString();

      return content;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;

    return file.writeAsString(data);
  }
}
