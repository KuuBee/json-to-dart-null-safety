// 不支持的json格式
class JsonToDartUnsupportedObjectError extends Error {
  final Object unsupportedObject;

  JsonToDartUnsupportedObjectError(this.unsupportedObject);

  @override
  String toString() {
    var safeString = Error.safeToString(unsupportedObject);
    return "当前Json不支持转换为Dart $safeString";
  }
}

// 数据库初始化失败
class DatabaseNotInitError extends Error {
  DatabaseNotInitError();

  @override
  String toString() {
    return "数据库未初始化！";
  }
}

// 数据库插入数据失败
class DatabaseInsertError extends Error {
  DatabaseInsertError(this.table, this.data);
  final String table;
  final Map<String, Object> data;

  @override
  String toString() {
    return "数据库插入数据失败！表：$table\ndata:$data\nstackTrace:$stackTrace";
  }
}
