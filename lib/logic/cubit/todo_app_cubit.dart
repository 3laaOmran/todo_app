
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/screens/archived_tasks.dart';
import 'package:todo_app/screens/done_tasks.dart';
import 'package:todo_app/screens/new_tasks_screen.dart';

part 'todo_app_state.dart';

class TodoAppCubit extends Cubit<TodoAppState> {
  TodoAppCubit() : super(TodoAppInitial());

  static TodoAppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> labels = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  Database? database;

  void createDatabase() {
    openDatabase(
      'todo.db', // بيشوف الاسم ده موجود والا لا لو موجود onopenولو مش موجود oncreate
      version: 1,
      onCreate: (database, version) {
        print('Database Created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error When Creating Tables ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database OPened');
      },
    ).then((value) {
      database = value;
      emit(TodoAppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(TodoAppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error inserting into database:${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(TodoAppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(TodoAppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(TodoAppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(TodoAppDeleteDatabaseState());
    });
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(TodoAppChangeBottomNavBarState());
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(TodoAppChangeBottomSheetState());
  }
}
