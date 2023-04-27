import 'package:flutter/material.dart';
import 'package:json_to_dart/app_data_model/file_model.dart';
import 'package:json_to_dart/app_data_model/project_model.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/error.dart';

class AppProvider extends ChangeNotifier {
  final Database db;
  MouseCursor _cursor = SystemMouseCursors.basic;
  List<ProjectModel> _projectList = [];
  Map<int, FileModel> _fileMap = {};

  AppProvider(this.db);

  List<ProjectModel> get projectList => _projectList;
  Map<int, FileModel> get fileMap => _fileMap;

  // app全局指针
  MouseCursor get cursor => _cursor;

  setAppCursors(MouseCursor cursor) {
    _cursor = cursor;
    notifyListeners();
  }

  initProject() async {
    final projectJSONList = await db.rawQuery("SELECT * FROM project");
    _projectList =
        projectJSONList.map((item) => ProjectModel.fromMap(item)).toList();
    notifyListeners();
  }

  insertProject(ProjectModel project) async {
    try {
      project.insertProject(db);
    } catch (e) {
      throw DatabaseInsertError('project', project.toMap());
    }
  }

  removeProject(int id) {
    // TODO 删除项目
    // TODO 删除项目下的文件
  }
}
