import 'dart:io';

import 'package:sqflite/sqflite.dart';

class ProjectModel {
  final int id;
  final String name;
  final List<FileMode> items;

  ProjectModel({required this.id, required this.name, required this.items});

  factory ProjectModel.fromMap(Map<String, dynamic> data) {
    return ProjectModel(
      id: data['id'],
      items: data['item'] ?? [],
      name: data['name'],
    );
  }

  Map<String, Object> toMap() => {
        "id": id,
        "name": name,
        "items": items,
      };

  static Future<Database> initTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS project (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        items TEXT 
    );""");
    return db;
  }

  Future<Database> insertProject(Database db) async {
    await db.rawInsert('INSERT INTO project(name, items) VALUES($name, ?)');
    return db;
  }
}
