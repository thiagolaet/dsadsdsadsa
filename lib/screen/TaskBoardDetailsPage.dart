import 'package:flutter/material.dart';
import 'package:planner/model/TaskBoard.dart';
import 'package:planner/model/Task.dart';
import 'package:planner/controller/TaskController.dart';

class TaskBoardDetailsPage extends StatefulWidget {
  final TaskBoard taskBoard;

  TaskBoardDetailsPage({required this.taskBoard});

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
    _tasks = await TaskController().getTasksByBoardId(widget.taskBoard.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskBoard.name),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_tasks[index].title),
                    subtitle: Text('Status: ${_tasks[index].isCompleted == 1 ? 'Completa' : 'Incompleta'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implementar a lógica de edição
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Implementar a lógica de deleção
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
