class JsonToDartUnsupportedObjectError extends Error {
  final Object unsupportedObject;

  JsonToDartUnsupportedObjectError(this.unsupportedObject);

  @override
  String toString() {
    var safeString = Error.safeToString(unsupportedObject);
    return "当前Json不支持转换为Dart $safeString";
  }
}

class AppDatabaseNotInitError extends Error {
  AppDatabaseNotInitError();

  @override
  String toString() {
    return "数据库未初始化！";
  }
}
