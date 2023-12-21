import 'package:flutter/material.dart';
import 'package:planner/model/Task.dart';
import 'package:planner/controller/TaskController.dart';
import 'package:planner/model/TaskBoard.dart';

class CreateTaskPage extends StatefulWidget {
  final TaskBoard taskBoard;
  final int userId;

  CreateTaskPage({required this.taskBoard, required this.userId});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _note = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  void _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Tarefa'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome da Tarefa'),
              onSaved: (value) => _title = value!,
              validator: (value) => value!.isEmpty ? 'Por favor, insira um nome' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Notas da Tarefa'),
              onSaved: (value) => _note = value!,
            ),
            TextButton(
              onPressed: () => _selectDate(context, true),
              child: Text('Selecionar Data de Início'),
            ),
            TextButton(
              onPressed: () => _selectDate(context, false),
              child: Text('Selecionar Data Final'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Task newTask = Task(
                    widget.userId,
                    widget.taskBoard.id ?? 0,
                    _title,
                    note: _note,
                    startTime: _startDate.toString(),
                    endTime: _endDate.toString(),
                    date: DateTime.now().toString(),
                    isCompleted: 0,
                  );
                  TaskController().saveTask(newTask).then((_) {
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
