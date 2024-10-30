import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo_model.dart';

class DatabaseHelper {
  static const _databaseName = 'MyTodo.db';
  static const _databaseVersion = 5;
  static const todoTable = 'todo';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $todoTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        is_done INTEGER NOT NULL DEFAULT 0
        )
        ''');
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<int> insertDb(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(todoTable, row);
  }

  Future<List<Todo>> readDb() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(todoTable);
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        is_done: maps[i]['is_done'] == 0 ? true : false,
      );
    });
  }

  Future<int> updateDb(Todo row) async {
    Database db = await instance.database;
    int id = row.id!;
    return await db
        .update(todoTable, row.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete(todoTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database ??= await _initDatabase();
    return _database!;
  }
}
