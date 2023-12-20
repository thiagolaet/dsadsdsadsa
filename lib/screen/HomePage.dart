import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  HomePage(this.signOut);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
             onPressed: () {
                signOut();
             },
             icon: Icon(Icons.lock_open),
           )
         ],
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}