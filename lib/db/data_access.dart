import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static final MyDatabase _instance = MyDatabase._internal();
  factory MyDatabase() => _instance;
  static Database? _database;

  MyDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'jay_matrimony_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE matrimonyusers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        mobile TEXT,
        address TEXT,
        dob TEXT,
        age INTEGER,
        gender TEXT,
        city TEXT,
        profession TEXT,
        cast TEXT,
        country TEXT,
        marital_status TEXT,
        salary_range TEXT,
        isfavorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      Database db = await database;
      return await db.query('matrimonyusers');
    } catch (e) {
      print("Database Error in getUsers(): $e");
      return [];
    }
  }

  Future<int> insertUser(Map<String, dynamic> userData) async {
    try {
      Database db = await database;
      return await db.insert('matrimonyusers', userData);
    } catch (e) {
      print("Error inserting user: $e");
      return -1;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'matrimonyusers',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteUser(int id) async {
    try {
      Database db = await database;
      return await db.delete('matrimonyusers', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting user: $e");
      return -1;
    }
  }

  Future<int> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      Database db = await database;
      return await db.update(
        'matrimonyusers',
        userData,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating user: $e");
      return -1;
    }
  }

  Future<int> updateUserFavorite(int id, int isFavorite) async {
    try {
      Database db = await database;
      return await db.update(
        'matrimonyusers',
        {'isfavorite': isFavorite},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating favorite status: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> searchMembers(String query) async {
    try {
      final db = await database;
      return await db.query(
        'matrimonyusers',
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
      );
    } catch (e) {
      print("Error in searchMembers(): $e");
      return [];
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
