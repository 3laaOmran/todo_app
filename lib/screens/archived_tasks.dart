import 'package:todo_app/logic/cubit/todo_app_cubit.dart';
import 'package:todo_app/widgets/tasks_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit, TodoAppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoAppCubit.get(context).archivedTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
