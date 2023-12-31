import 'package:flutter/material.dart';
import 'package:planner/model/TaskBoard.dart';
import 'package:planner/model/Task.dart';
import 'package:planner/controller/TaskController.dart';
import 'CreateTaskPage.dart';
import 'package:intl/intl.dart';

class TaskBoardDetailsPage extends StatefulWidget {
  final TaskBoard taskBoard;
  final int userId;

  TaskBoardDetailsPage({required this.taskBoard, required this.userId});

  @override
  _TaskBoardDetailsPageState createState() => _TaskBoardDetailsPageState();
}

class _TaskBoardDetailsPageState extends State<TaskBoardDetailsPage> {
  late List<Task> _tasks;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    _tasks = await TaskController().getTasksByBoardIdAndUserId(widget.taskBoard.id, widget.userId);
    setState(() {
      _isLoading = false;
    });
  }

  _deleteTask(Task task) async {
    await TaskController().deleteTask(task);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskBoard.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskPage(taskBoard: widget.taskBoard, userId: widget.userId)),
          ).then((value) => _loadTasks());
        },
        child: Icon(Icons.add),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _tasks[index].isCompleted = _tasks[index].isCompleted == 1 ? 0 : 1;
                      TaskController().saveTask(_tasks[index]);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(_tasks[index].title),
                      subtitle: Text('Status: ${_tasks[index].isCompleted == 1 ? 'Completa' : 'Incompleta'} | Data de Início: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_tasks[index].startTime ?? ''))} | Data de Fim: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_tasks[index].endTime ?? ''))}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTaskPage(taskBoard: widget.taskBoard, userId: widget.userId, taskInitialData: _tasks[index]),
                              ),
                            ).then((_) => {
                              _loadTasks()
                            });
                          },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteTask(_tasks[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
