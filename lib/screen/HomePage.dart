import 'package:flutter/material.dart';
import 'package:planner/controller/TaskBoardController.dart';
import 'package:planner/model/TaskBoard.dart';
import 'TaskBoardDetailsPage.dart';
import 'CreateTaskBoardPage.dart';
import 'RecentTasksPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  HomePage(this.signOut);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskBoardController _controller = TaskBoardController();
  List<TaskBoard> _taskBoards = [];
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _getUserId().then((value) => {
      userId = value!,
      _loadTaskBoards()
    });
  }

  _loadTaskBoards() async {
    var taskBoards = await _controller.getAllTaskBoard();
    setState(() {
      _taskBoards = taskBoards;
    });
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              widget.signOut();
            },
            icon: Icon(Icons.logout),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecentTasksPage(userId: this.userId,)),
              );
            },
            child: Text('Tarefas recentes'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskBoardPage()),
          ).then((_) => {
            _loadTaskBoards()
          });
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _taskBoards.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskBoardDetailsPage(taskBoard: _taskBoards[index], userId: userId),
                ),
              ).then((_) => {
                _loadTaskBoards()
              });
            },
            child: Card(
              child: ListTile(
                title: Text(_taskBoards[index].name),
                subtitle: FutureBuilder<int>(
                  future: _controller.countTasks(_taskBoards[index].id, this.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text('Número de tarefas: ${snapshot.data}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
