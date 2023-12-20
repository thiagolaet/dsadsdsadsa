import 'package:flutter/material.dart';
import 'package:planner/controller/TaskBoardController.dart';
import 'package:planner/model/TaskBoard.dart';

class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  HomePage(this.signOut);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskBoardController _controller = TaskBoardController();
  List<TaskBoard> _taskBoards = [];

  @override
  void initState() {
    super.initState();
    _loadTaskBoards();
  }

  _loadTaskBoards() async {
    var taskBoards = await _controller.getAllTaskBoard();
    setState(() {
      _taskBoards = taskBoards;
    });
  }

 signOut() {
   setState(() {
     widget.signOut();
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _taskBoards.length,
        itemBuilder: (context, index) {
          return FutureBuilder<int>(
            future: _controller.countTasks(_taskBoards[index].id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Card(
                  child: ListTile(
                    title: Text(_taskBoards[index].name),
                    subtitle: Text('Número de tarefas: ${snapshot.data}'),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}