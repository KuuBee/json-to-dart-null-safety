import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:json_to_dart/app_data_model/file_model.dart';
import 'package:json_to_dart/app_data_model/project_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart' as p;

import '../utils/error.dart';

class AppDatebaseProvider extends ChangeNotifier {
  // 数据库实例
  Database? _db;
  // 数据库是否初始化完成
  bool _loading = true;

  bool get loading => _loading;

  Database get db {
    if (_db == null) {
      throw AppDatabaseNotInitError();
    }
    return _db!;
  }

  // 数据库初始化
  Future<Database> initDb() async {
    Database database;
    if (kIsWeb) {
      // Change default factory on the web
      final databaseFactory = databaseFactoryFfiWeb;
      const path = 'app_web.db';
      database = await databaseFactory.openDatabase(path);
    }
    var databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'app.db');
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      database = await databaseFactory.openDatabase(path);
    }
    // mac ios android
    database = await openDatabase(path);
    _db = database;
    await ProjectModel.initTable(database);
    await FileModel.initTable(database);
    _loading = false;
    notifyListeners();
    return database;
  }
}
