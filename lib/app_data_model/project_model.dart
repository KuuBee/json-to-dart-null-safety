import 'dart:io';

import 'package:sqflite/sqflite.dart';

class ProjectModel {
  final int id;
  final String name;
  final List<FileMode> items;

  ProjectModel({required this.id, required this.name, required this.items});

  static initTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS project (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        items TEXT 
    );""");
  }
}
