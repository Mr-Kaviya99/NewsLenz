import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/news_article.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            url TEXT,
            urlToImage TEXT,
            publishedAt TEXT,
            publishedTime TEXT,
            viewsCount INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertFavorite(NewsArticle article) async {
    final db = await database;
    await db.insert(
      'favorites',
      article.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeFavorite(String title) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  static Future<List<NewsArticle>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return NewsArticle.fromJson(maps[i]);
    });
  }
}
