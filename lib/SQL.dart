import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class SQL {
  SQL._();
  static final SQL db = SQL._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Notes.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Notes ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "note TEXT NOT NULL,"
          "date INTEGER NOT NULL"
          ")");
    });
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    int res = await db.insert("Notes", note.toJson());
    return res;
  }

  Future<int> deleteNote(Note note) async {
    final db = await database;
    var res = await db.delete("Notes", where: "id = ?", whereArgs: [note.id]);
    return res;
  }

  Future<List<Note>> loadAllNotes () async {
    final db = await database;
    var res = await db.query("Notes", orderBy: "date desc");
    List<Note> list =
        res.isNotEmpty ? res.map((c) => Note.fromJson(c)).toList() : [];
    return list;
  }

  Future <List<Note>>loadWithOffset (int amount, int offset) async {
    final db = await database;
    var res =await  db.query("Notes", limit: amount, offset: offset);
    List<Note> list =
        res.isNotEmpty ? res.map((c) => Note.fromJson(c)).toList() : [];
    return list;
  }

  Future<Note>loadById (Note note) async {
    final db = await database;
    var res = await  db.query("Notes", where: "id = ?", whereArgs: [note.id]);
    return res.isNotEmpty ? Note.fromJson(res.first) : Null;
  }

  Future<int> updateById (Note note) async {
    final db = await database;
    var res = await db.update("Notes", note.toJson(),
        where: "id = ?", whereArgs: [note.id]);
    return res;
  }
}