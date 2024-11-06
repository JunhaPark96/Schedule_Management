import 'package:oneline2/admin_list/feature/Page1_Todo/models/todo_model.dart';

//상태는 전체 그룹과 필터링 된 그룹을 모두 포함 하여 관리

class TodoState {
  final List<TodoModel> todolist;
  final List<TodoModel> filterlist;
  final List<TodoModel> completedlist;
  final bool loading;
  final String error;
  TodoState({
    required this.loading,
    required this.todolist,
    required this.completedlist,
    this.error = '',
    required this.filterlist,
  });

  TodoState copyWith({
    List<TodoModel>? todolist,
    List<TodoModel>? filterlist,
    List<TodoModel>? completedlist,
    bool? loading,
    String? error,
  }) {
    return TodoState(
      todolist: todolist ?? this.todolist,
      filterlist: filterlist ?? this.filterlist,
      completedlist: completedlist ?? this.completedlist,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
