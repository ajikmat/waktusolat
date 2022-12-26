import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class Storage {
  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getFile(String month, String zone) async {
    final path = await getFilePath();

    return File('$path/$month-$zone.json');
  }

  Future<File> saveToFile(var data, String month, String zone) async {
    final file = await getFile(month, zone);
    return file.writeAsString(data);
  }

  Future<String> readFromFile(String month, String zone) async {
    try {
      final file = await getFile(month, zone);
      String fileContents = await file.readAsString();

      return fileContents;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }
}

class Storage2 {
  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getFile(String zone) async {
    final path = await getFilePath();

    return File('$path/$zone.json');
  }

  Future<File> saveToFile(var data, String zone) async {
    final file = await getFile(zone);
    return file.writeAsString(data);
  }

  Future<String> readFromFile(String zone) async {
    try {
      final file = await getFile(zone);
      String fileContents = await file.readAsString();

      return fileContents;
    } catch (e) {
      throw (e);
    }
  }
}
