import 'package:flutter/material.dart';
import 'package:planner/model/Task.dart';
import 'package:planner/controller/TaskController.dart';
import 'package:intl/intl.dart';

class CompletedTasksPage extends StatefulWidget {
  final int userId;

  CompletedTasksPage({required this.userId});

  @override
  _CompletedTasksPageState createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks();
  }

  _loadCompletedTasks() async {
    _tasks = await TaskController().getCompletedTasks(widget.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefas Concluídas"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_tasks[index].title),
                    subtitle: Text('Status: ${_tasks[index].isCompleted == 1 ? 'Completa' : 'Incompleta'} | Data de Início: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_tasks[index].startTime ?? ''))} | Data de Fim: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_tasks[index].endTime ?? ''))}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                  ),
                ));
              },
            ),
    );
  }
}
