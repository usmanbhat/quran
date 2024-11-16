import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'your_database.db');

    // Check if the database exists
    final exists = await databaseExists(path);

    if (!exists) {
      // If the database does not exist, copy it from assets
      try {
        await Directory(dirname(path)).create(recursive: true);

        ByteData data =
            await rootBundle.load(join('assets', 'your_database.db'));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print('Error copying database: $e');
      }
    }

    return await openDatabase(path);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
