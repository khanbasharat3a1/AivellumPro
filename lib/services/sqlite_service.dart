import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../models/category.dart';
import '../models/prompt.dart';

class SQLiteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'prompts.db');

    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load('assets/data/prompts.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: 1);
  }

  static Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories', orderBy: 'id');
    
    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'] ?? '',
        icon: maps[i]['icon'] ?? '',
        promptCount: maps[i]['prompt_count'] ?? 0,
      );
    });
  }

  static Future<List<Prompt>> getPrompts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('prompts', orderBy: 'id');
    
    return List.generate(maps.length, (i) {
      return Prompt(
        id: maps[i]['id'].toString(),
        categoryId: maps[i]['category_id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        content: maps[i]['content'],
        isPremium: maps[i]['is_premium'] == 1,
        difficulty: maps[i]['difficulty'],
        estimatedTime: maps[i]['estimated_time'],
        tags: List<String>.from(json.decode(maps[i]['tags'] ?? '[]')),
        isUnlocked: true,
        isFavorite: false,
      );
    });
  }

  static Future<List<Prompt>> getPromptsByCategory(String categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prompts',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'id',
    );
    
    return List.generate(maps.length, (i) {
      return Prompt(
        id: maps[i]['id'].toString(),
        categoryId: maps[i]['category_id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        content: maps[i]['content'],
        isPremium: maps[i]['is_premium'] == 1,
        difficulty: maps[i]['difficulty'],
        estimatedTime: maps[i]['estimated_time'],
        tags: List<String>.from(json.decode(maps[i]['tags'] ?? '[]')),
        isUnlocked: true,
        isFavorite: false,
      );
    });
  }

  static Future<List<Prompt>> searchPrompts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'prompts',
      where: 'title LIKE ? OR description LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'id',
    );
    
    return List.generate(maps.length, (i) {
      return Prompt(
        id: maps[i]['id'].toString(),
        categoryId: maps[i]['category_id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        content: maps[i]['content'],
        isPremium: maps[i]['is_premium'] == 1,
        difficulty: maps[i]['difficulty'],
        estimatedTime: maps[i]['estimated_time'],
        tags: List<String>.from(json.decode(maps[i]['tags'] ?? '[]')),
        isUnlocked: true,
        isFavorite: false,
      );
    });
  }
}
