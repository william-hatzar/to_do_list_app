import 'package:flutter/material.dart';
import 'views/ToDoListScreen.dart';

void main() => runApp(const Root());

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "To Do List App",
      home: ToDoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}