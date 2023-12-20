import 'package:flutter/material.dart';
import 'screen/LoginPage.dart';

final routes = {
  '/': (BuildContext context) => LoginPage(),
  '/login': (BuildContext context) => LoginPage(),
};

void main() {
  runApp(MaterialApp(
    title: "Login",
    debugShowCheckedModeBanner: false,
    theme:  new ThemeData(primarySwatch: Colors.teal),
    routes: routes,
  ));
}