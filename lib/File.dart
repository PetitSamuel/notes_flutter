import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes_stored.txt');
  }

  static Future<List<String>> readNotes() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents.split("\n");
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  static Future<List<String>> removeNote(String s) async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      print(contents);
      contents.replaceFirst("$s\n", "");

      file.writeAsString(contents, mode: FileMode.write);
      return contents.split("\n");
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  static Future<File> writeNote(String note) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString("$note\n", mode: FileMode.append);
  }
}