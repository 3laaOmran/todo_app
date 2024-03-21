part of 'todo_app_cubit.dart';

@immutable
sealed class TodoAppState {}

final class TodoAppInitial extends TodoAppState {}

final class TodoAppChangeBottomNavBarState extends TodoAppState {}

final class TodoAppCreateDatabaseState extends TodoAppState {}

final class TodoAppGetDatabaseState extends TodoAppState {}

final class TodoAppUpdateDatabaseState extends TodoAppState {}

final class TodoAppDeleteDatabaseState extends TodoAppState {}

final class TodoAppGetDatabaseLoadingState extends TodoAppState {}

final class TodoAppInsertDatabaseState extends TodoAppState {}

final class TodoAppChangeBottomSheetState extends TodoAppState {}


