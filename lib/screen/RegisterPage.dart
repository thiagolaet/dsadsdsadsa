import 'package:flutter/material.dart';
import 'package:planner/controller/LoginController.dart';
import 'package:planner/screen/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

enum LoginStatus { notSignIn, signIn }

class RegisterPage extends StatefulWidget {  
  final VoidCallback signOut;
  const RegisterPage(this.signOut);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? _name, _email, _password;
  final _formKey = GlobalKey<FormState>();
  late LoginController controller;
  var value;

  _RegisterPageState() {
    this.controller = LoginController();
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {      
      form.save();

      try{
        User user = await controller.registerUser(_name!, _email!, _password!);
        if (user.id != -1) {
          savePref(1, user.name, user.email, user.password, user.id ?? -1);
          _loginStatus = LoginStatus.signIn;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already in use!')),
          );
        }
      } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );     
      }
      

    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  savePref(int value, String name, String email, String pass, int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("pass", pass);
      preferences.setInt("userId", userId);
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            appBar: AppBar(
              title: Text("Register Page"),
            ),
            body: Container(
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _name = newValue,
                              decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _email = newValue,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (newValue) => _password = newValue,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          )
                        ]
                      ,)
                    ),
                    ElevatedButton(
                      onPressed: _submit, 
                      child: Text("Register"),
                      
                    )
                  
                  ],
                ),
              ),
            ),
          );
        case LoginStatus.signIn:
          return HomePage(signOut);
    }
    
  }
}