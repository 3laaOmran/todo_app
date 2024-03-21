import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_app_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  TodoAppScreen(),
    );
  }
}
