import 'package:todo_app/logic/cubit/todo_app_cubit.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TodoAppScreen extends StatelessWidget {
  TodoAppScreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var taskTitleController = TextEditingController();
  var taskTimeController = TextEditingController();
  var taskDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoAppCubit()..createDatabase(),
      child: BlocConsumer<TodoAppCubit, TodoAppState>(
        listener: (context, state) {
          if (state is TodoAppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoAppCubit cubit = TodoAppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBar(
              toolbarHeight: 80,
              centerTitle: true,
              backgroundColor: Color(0xff6c63ff),
              title: Text(
                cubit.labels[cubit.currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: taskTitleController.text,
                      date: taskDateController.text,
                      time: taskTimeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customTextFormField(
                                    controller: taskTitleController,
                                    type: TextInputType.text,
                                    labelText: 'Task Title',
                                    prefix: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Task title must not be empty';
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                customTextFormField(
                                    controller: taskTimeController,
                                    type: TextInputType.datetime,
                                    labelText: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        taskTimeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Task Time must not be empty';
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                customTextFormField(
                                    controller: taskDateController,
                                    type: TextInputType.datetime,
                                    labelText: 'Task Date',
                                    prefix: Icons.date_range_outlined,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2024-05-01'),
                                      ).then((value) {
                                        taskDateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Task Date must not be empty';
                                      }
                                      return null;
                                    }),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              backgroundColor: Color(0xff6c63ff),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
            ),
            body: state is! TodoAppGetDatabaseLoadingState
                ? cubit.screens[cubit.currentIndex]
                : const Center(
                    child: CircularProgressIndicator(
                    color: Colors.blue,
                  )),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline_outlined,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
