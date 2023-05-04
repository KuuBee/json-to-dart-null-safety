import 'package:sqflite/sqflite.dart';

import '../utils/error.dart';

class FileModel {
  final int id;
  // 文件名
  final String name;
  // 用户传的json字符串
  final String? jsonStr;
  // json 转的 dart类字符串
  final String? dartClassStr;
  // json_serializable  字符串
  final String? jsonSerializationStr;

  FileModel({
    required this.id,
    required this.name,
    this.jsonStr,
    this.dartClassStr,
    this.jsonSerializationStr,
  });

  factory FileModel.fromMap(Map<String, dynamic> data) {
    return FileModel(
      id: data['id'],
      name: data['name'],
      jsonStr: data['json_str'],
      dartClassStr: data['dart_class_str'],
      jsonSerializationStr: data['json_serialization_str'],
    );
  }

  static fromId(int id) async {
    final fileList = await _db.rawQuery('SELECT * FROM file WHERE ID = $id ');
    if (fileList.isEmpty) {
      throw GenericError("id 查询无效");
    }
    final file = fileList[0];
    return FileModel.fromMap(file);
  }

  static late Database _db;
  static initDb(Database db) {
    _db = db;
  }

  static initTable() async {
    await _db.execute("""
    CREATE TABLE IF NOT EXISTS file (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        json_str TEXT 
        dart_class_str TEXT 
        json_serialization_str TEXT 
    );""");
  }

  insert() async {
    await _db.rawInsert(
        'INSERT INTO file(name, json_str, dart_class_str, json_serialization_str) VALUES($name, ${jsonStr ?? '?'}, ${dartClassStr ?? '?'}, ${jsonSerializationStr ?? '?'})');
  }

  remove() async {
    await _db.rawInsert('DELETE FROM file WHERE ID = $id');
  }
}
