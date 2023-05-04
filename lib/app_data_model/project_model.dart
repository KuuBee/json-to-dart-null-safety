import 'package:sqflite/sqflite.dart';

import 'file_model.dart';

class ProjectModel {
  final int id;
  final String name;
  final List<FileModel> items;

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

  static late Database _db;
  static initDb(Database db) {
    _db = db;
  }

  static initTable() async {
    await _db.execute("""
    CREATE TABLE IF NOT EXISTS project (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        items TEXT 
    );""");
  }

  insert() async {
    await _db.rawInsert('INSERT INTO project(name, items) VALUES($name, ?)');
  }

  remove() async {
    await _db.rawInsert('DELETE FROM project WHERE ID = $id');
  }
}
