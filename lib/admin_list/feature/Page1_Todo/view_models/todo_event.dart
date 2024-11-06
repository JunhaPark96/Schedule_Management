import 'package:oneline2/admin_list/feature/Page1_Todo/models/todo_model.dart';

abstract class TodoEvent {}

class FetchTodos extends TodoEvent {}

class CompletedTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final TodoModel addevent;
  AddTodo(this.addevent);
}

class RemoveTodo extends TodoEvent {
  final TodoModel removeevent;
  RemoveTodo(this.removeevent);
}

class ModifyTodo extends TodoEvent {
  final TodoModel modifyevent;
  ModifyTodo(this.modifyevent);
}

class FilterTodos extends TodoEvent {
  final String query;

  FilterTodos(this.query);
}
