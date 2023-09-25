import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int version = 1;
  static const String databaseName = 'Notes.db';
  static const String tableName1 = 'noteTable';
  static const String tableName2 = 'folderTable';
  static const String tableName3 = 'staredNoteTable';
  static const String tableName4 = 'staredFolderTable';
  static const String column1 = 'id';
  static const String column2 = 'title';
  static const String column3 = 'description';
  static const String column4 = 'category';
  static const String column5 = 'dateTime';
  static const String column6 = 'isStared';

//************************* Database Initialization **********************
  static Future<Database> getDb() async {
    var databasesPath = await getDatabasesPath();
    return openDatabase(join(databasesPath, databaseName),
        onCreate: (db, version) async {
      debugPrint("Creating database with version $version");
      await _createTable1(db);
      await _createTable2(db);
      await _createTable3(db);
      await _createTable4(db);
    }, version: version);
  }

  // *********************** Notes Database *******************************
  static Future<void> _createTable1(Database db) async {
    await db.execute(
      "CREATE TABLE $tableName1("
      "'$column1' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "'$column2' TEXT, "
      "'$column3' TEXT, "
      "'$column4' TEXT, "
      "'$column5' TEXT, "
      "'$column6' INTEGER"
      ");",
    );
  }

  static Future<int> addNote(Notes notes) async {
    final db = await getDb();
    return await db.insert(tableName1, notes.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(Notes notes) async {
    final db = await getDb();
    return await db.update(tableName1, notes.toJson(),
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> isStaredNote(Notes notes, int isStared) async {
    final db = await getDb();
    final Map<String, dynamic> updatedData = {
      'isStared': isStared,
    };
    return await db.update(tableName1, updatedData,
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(Notes notes) async {
    final db = await getDb();
    return await db.delete(tableName1, where: 'id=?', whereArgs: [notes.id]);
  }

  static Future<List<Notes>?> getAllNotes() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(tableName1);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (index) => Notes.fromJson(maps[index]));
  }


  // **************** Folder Database *******************************
  static Future<void> _createTable2(Database db) async {
    await db.execute(
      "CREATE TABLE $tableName2("
      "'$column1' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "'$column2' TEXT, "
      "'$column3' TEXT, "
      "'$column4' TEXT, "
      "'$column5' TEXT, "
      "'$column6' INTEGER"
      ");",
    );
  }

  static Future<int> addCategory(Notes notes) async {
    final db = await getDb();
    return await db.insert(tableName2, notes.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateCategory(Notes notes) async {
    final db = await getDb();
    return await db.update(tableName2, notes.toJson(),
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> isStaredFolder(Notes notes, int isStared) async {
    final db = await getDb();
    // Create a map with the updated "age" field.
    final Map<String, dynamic> updatedData = {
      'isStared': isStared,
    };
    return await db.update(tableName2, updatedData,
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteCategory(Notes notes) async {
    final db = await getDb();
    return await db.delete(tableName2, where: 'id=?', whereArgs: [notes.id]);
  }

  static Future<List<Notes>?> getAllCategory() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(tableName2);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (index) => Notes.fromJson(maps[index]));
  }


  //*********************** Stared Note/Folder Database ********************
  static Future<void> _createTable3(Database db) async {
    await db.execute(
      "CREATE TABLE $tableName3("
      "'$column1' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "'$column2' TEXT, "
      "'$column3' TEXT, "
      "'$column4' TEXT, "
      "'$column5' TEXT, "
      "'$column6' INTEGER"
      ");",
    );
  }

  static Future<void> _createTable4(Database db) async {
    await db.execute(
      "CREATE TABLE $tableName4("
      "'$column1' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "'$column2' TEXT, "
      "'$column3' TEXT, "
      "'$column4' TEXT, "
      "'$column5' TEXT, "
      "'$column6' INTEGER"
      ");",
    );
  }


  //***************** Stared Notes Database *******************************
  static Future<int> addStaredNote(Notes notes) async {
    final db = await getDb();
    return await db.insert(tableName3, notes.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateStaredNote(Notes notes) async {
    final db = await getDb();
    return await db.update(tableName3, notes.toJson(),
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateIsStaredNote(Notes notes, int isStared) async {
    final db = await getDb();
    final Map<String, dynamic> updatedData = {
      'isStared': isStared,
    };
    return await db.update(tableName3, updatedData,
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> removeStaredNote(Notes notes) async {
    final db = await getDb();
    return await db.delete(tableName3, where: 'id=?', whereArgs: [notes.id]);
  }

  static Future<List<Notes>?> getAllStaredNotes() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(tableName3);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (index) => Notes.fromJson(maps[index]));
  }



  ///**************** Stared Folder Database *************************
  //Add New Folder
  static Future<int> addStaredFolder(Notes notes) async {
    final db = await getDb();
    return await db.insert(tableName4, notes.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Stared Status Update
  static Future<int> updateStaredFolder(Notes notes) async {
    final db = await getDb();
    return await db.update(tableName4, notes.toJson(),
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Check Stared Folder
  static Future<int> updateIsStaredFolder(Notes notes, int isStared) async {
    final db = await getDb();
    final Map<String, dynamic> updatedData = {
      'isStared': isStared,
    };
    return await db.update(tableName4, updatedData,
        where: 'id=?',
        whereArgs: [notes.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Remove Stared Status
  static Future<int> removeStaredFolder(Notes notes) async {
    final db = await getDb();
    return await db.delete(tableName4, where: 'id=?', whereArgs: [notes.id]);
  }

  //Get all Stared Folder
  static Future<List<Notes>?> getAllStaredFolder() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(tableName4);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (index) => Notes.fromJson(maps[index]));
  }
}
