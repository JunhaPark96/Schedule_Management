import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/models/todo_model.dart';

import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_event.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_state.dart';
import '../repos/todo_repos.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc()
      : super(
          TodoState(
            todolist: [],
            filterlist: [],
            completedlist: [],
            loading: true,
            error: '',
          ),
        ) {
    on<FetchTodos>(_onFetchTodos);
    on<RemoveTodo>(_onRemoveTodo);
    on<AddTodo>(_onAddTodo);
    on<ModifyTodo>(_onModifyTodo);
    on<FilterTodos>(_onFilterTodo); //event name
  }

  void _onFetchTodos(FetchTodos event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<TodoModel> todos = await ApiService().fetchData();
      List<TodoModel> progress =
          todos.where((element) => !element.isCompleted!).toList();
      List<TodoModel> completed =
          todos.where((element) => element.isCompleted!).toList();
      emit(state.copyWith(
          todolist: todos,
          filterlist: progress,
          completedlist: completed,
          loading: false));
      // print('todolist: ${state.todolist.length}');
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> _onRemoveTodo(RemoveTodo event, Emitter<TodoState> emit) async {
    try {
      await ApiService().deleteData(event.removeevent); //백엔드 데이터 삭제 수행
      final removeTodos = state.todolist.where((instance) {
        return instance.id != event.removeevent.id;
      }).toList();
      final filteredremoveTodos = state.filterlist.where((element) {
        return element.id != event.removeevent.id && !element.isCompleted!;
      }).toList();
      final completedremoveTodos = state.completedlist.where((element) {
        return element.id != event.removeevent.id && element.isCompleted!;
      }).toList();

      emit(state.copyWith(
          todolist: removeTodos,
          filterlist: filteredremoveTodos,
          completedlist: completedremoveTodos,
          loading: false));
    } catch (e) {
      // debugPrint('Error : $e');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onModifyTodo(ModifyTodo event, Emitter<TodoState> emit) async {
    try {
      await ApiService().updateData(event.modifyevent);

      List<TodoModel> filteredupdateTodos = state.filterlist.map((element) {
        return (element.id == event.modifyevent.id)
            ? event.modifyevent
            : element;
      }).toList();
      List<TodoModel> filterecompletedTodos =
          state.completedlist.map((element) {
        return (element.id == event.modifyevent.id)
            ? event.modifyevent
            : element;
      }).toList();

      emit(state.copyWith(
        filterlist: filteredupdateTodos,
        completedlist: filterecompletedTodos,
      ));
      // print(event.modifyevent.isCompleted);
    } catch (e) {
      // debugPrint('Error : $e');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      final addedTodo = await ApiService().insertData(event.addevent);
      // final updateTodos = List<TodoModel>.from(state.todolist)..add(addedTodo);
      final filteredupdateTodos = List<TodoModel>.from(state.filterlist)
        ..add(addedTodo);
      if (event.addevent.isCompleted!) {
        var filteredcompletedTodos = List<TodoModel>.from(state.completedlist)
          ..add(addedTodo);
        emit(state.copyWith(
            filterlist: filteredupdateTodos,
            completedlist: filteredcompletedTodos));
      } else {
        emit(state.copyWith(filterlist: filteredupdateTodos));
      }
    } catch (e) {
      // debugPrint('Error : $e');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onFilterTodo(FilterTodos event, Emitter<TodoState> emit) {
    final query = event.query; //TodoEvent>FilterTodos>query
    if (query.isEmpty) {
      emit(state.copyWith(
          filterlist: state.todolist, loading: false, error: ''));
      print('-empty list -');
    } else {
      final List<TodoModel> filtered =
          state.todolist.where((list) => _matchesQuery(list, query)).toList();
      // print('Filtered value : ${filtered.length}');
      emit(state.copyWith(
        filterlist: filtered,
        completedlist: filtered,
        loading: false,
        error: '',
      ));
    }
  }

  bool _matchesQuery(TodoModel list, String query) {
    String normalizedQuery = _normalize(query);
    // print(list.title!);
    return _normalize(list.title!).contains(normalizedQuery) ||
        _normalize(list.description!).contains(normalizedQuery);
  }

  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[\s+]', multiLine: true), '');
  }
}
