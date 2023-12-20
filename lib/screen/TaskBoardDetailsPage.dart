import 'package:flutter/material.dart';
import 'package:planner/model/TaskBoard.dart';

class TaskBoardDetailsPage extends StatelessWidget {
  final TaskBoard taskBoard;

  TaskBoardDetailsPage({required this.taskBoard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskBoard.name),
      ),
      body: Container(
        // Aqui você pode adicionar mais detalhes sobre o TaskBoard
        child: Center(
          child: Text("Detalhes do TaskBoard: ${taskBoard.name}"),
        ),
      ),
    );
  }
}
