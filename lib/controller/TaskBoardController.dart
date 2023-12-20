
import 'package:planner/helper/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

import '../model/TaskBoard.dart';

class TaskBoardController {
  DatabaseHelper con = DatabaseHelper();

  Future<int> saveTaskBoard(TaskBoard taskboard) async {
    var db = await con.db;
    int res = await db.insert('task_board', taskboard.toMap());
    return res;
  }

  Future<int> deleteTaskBoard(TaskBoard taskboard) async {
    var db = await con.db;
    int res = await db.delete("task_board", where: "id = ?", whereArgs: [taskboard.id]);
    return res;
  }

  Future<List<TaskBoard>> getAllTaskBoard() async {
    var db = await con.db;
    var res = await db.query("task_board");

    List<TaskBoard> list = res.isNotEmpty ? res.map((c) => TaskBoard.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> countTasks(int? boardId) async {
    var db = await con.db;
    var res = await db.rawQuery('SELECT COUNT(*) FROM task WHERE board_id = ?', [boardId]);
    return Sqflite.firstIntValue(res) ?? 0;
  }
}