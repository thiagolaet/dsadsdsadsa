
import 'package:planner/helper/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Task.dart';

class TaskController {
  DatabaseHelper con = DatabaseHelper();

  Future<int> saveTask(Task task) async {
    var db = await con.db;
    if (task.id != null) {
      return await db.update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    }
    int res = await db.insert('task', task.toMap());
    return res;
  }

  Future<int> deleteTask(Task task) async {
    var db = await con.db;
    int res = await db.delete("task", where: "id = ?", whereArgs: [task.id]);
    return res;
  }

  Future<List<Task>> getRecentTasks(int userId) async {
    var db = await con.db;
    DateTime now = DateTime.now().subtract(Duration(days: 1));

    DateTime sevenDaysLater = now.add(Duration(days: 8));

    var res = await db.query(
      "task",
      where: "user_id = ? AND startTime >= ? AND startTime <= ?",
      whereArgs: [userId, now.toIso8601String(), sevenDaysLater.toIso8601String()],
      orderBy: "startTime ASC"
    );

    List<Task> tasks = res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return tasks;
  }

  Future<List<Task>> getCompletedTasks(int userId) async {
    var db = await con.db;

    var res = await db.query(
      "task",
      where: "user_id = ? AND isCompleted = 1",
      whereArgs: [userId],
      orderBy: "startTime ASC"
    );

    List<Task> tasks = res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return tasks;
  }

  Future<List<Task>> getTasksByBoardIdAndUserId(int? boardId, int? userId) async {
    var db = await con.db;
    var res = await db.query("task", where: "board_id = ? AND user_id = ?", whereArgs: [boardId, userId], orderBy: "startTime ASC");

    List<Task> list = res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }
}