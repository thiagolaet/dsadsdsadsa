import 'package:flutter/material.dart';
import 'package:planner/controller/TaskBoardController.dart';
import 'package:planner/model/TaskBoard.dart';

class CreateTaskBoardPage extends StatefulWidget {
  @override
  _CreateTaskBoardPageState createState() => _CreateTaskBoardPageState();
}

class _CreateTaskBoardPageState extends State<CreateTaskBoardPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _color = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar TaskBoard'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome'),
              onSaved: (value) {
                _name = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira um nome';
                }
                return null;
              },
            ),
            DropdownButtonFormField<int>(
              value: _color,
              decoration: InputDecoration(labelText: 'Cor'),
              items: List<DropdownMenuItem<int>>.generate(
                5,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('Cor ${(index + 1)}'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _color = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  TaskBoard newTaskBoard = TaskBoard(_name, color: _color);
                  TaskBoardController().saveTaskBoard(newTaskBoard).then((_) {
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
