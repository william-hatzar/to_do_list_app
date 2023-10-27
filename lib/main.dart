import 'package:flutter/material.dart';
import 'views/ToDoListScreen.dart';
import 'package:provider/provider.dart';

import 'package:to_do_list_app/state/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const Root(),
    ),
  );
}

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