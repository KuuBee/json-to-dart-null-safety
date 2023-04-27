import 'package:sqflite/sqflite.dart';

class FileModel {
  final int id;
  // 文件名
  final String name;
  // 用户传的json字符串
  final String jsonStr;
  // json 转的 dart类字符串
  final String dartClassStr;
  // json_serializable  字符串
  final String jsonSerializationStr;

  FileModel({
    required this.id,
    required this.jsonStr,
    required this.dartClassStr,
    required this.jsonSerializationStr,
    required this.name,
  });
  static Future<Database> initTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS file (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        json_str TEXT 
        dart_class_str TEXT 
        json_serialization_str TEXT 
    );""");
    return db;
  }
}
