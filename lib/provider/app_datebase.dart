import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:json_to_dart/app_data_model/file_model.dart';
import 'package:json_to_dart/app_data_model/project_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart' as p;

import '../utils/error.dart';

class AppDatebaseProvider extends ChangeNotifier {
  AppDatebaseProvider() {
    if (AppDatebaseProvider._database == null) {
      throw DatabaseNotInitError();
    }
    db = AppDatebaseProvider._database!;
  }
  // 数据库实例
  late final Database db;

  static Database? _database;

  // 数据库初始化
  static Future<Database> initDb() async {
    Database database;
    if (kIsWeb) {
      // Change default factory on the web
      final databaseFactory = databaseFactoryFfiWeb;
      const path = 'app_web.db';
      database = await databaseFactory.openDatabase(path);
    }
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      databaseFactory = databaseFactoryFfi;
      final path = p.join(
        appDocumentsDir.path,
        'json_to_dart',
        'app.db',
      );
      database = await databaseFactory.openDatabase(path);
    } else {
      var databasesPath = await getDatabasesPath();
      final path = p.join(databasesPath, 'app.db');
      // mac ios android
      database = await openDatabase(path);
    }
    _database = database;
    ProjectModel.initDb(database);
    FileModel.initDb(database);
    await ProjectModel.initTable();
    await FileModel.initTable();
    return database;
  }
}
