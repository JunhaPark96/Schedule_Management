import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/models/memo_model.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_event.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_state.dart';
import '../repos/memo_repos.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  MemoBloc()
      : super(
          MemoState(
            memolist: [],
            filterlist: [],
            completedlist: [],
            loading: true,
            error: '',
          ),
        ) {
    on<FetchMemo>(_onFetchMemo);
    on<RemoveMemo>(_onRemoveMemo);
    on<AddMemo>(_onAddMemo);
    on<ModifyMemo>(_onModifyMemo);
    on<FilterMemo>(_onFilterMemo); //event name
  }

  void _onFetchMemo(FetchMemo event, Emitter<MemoState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<MemoModel> todos = await ApiService().fetchData();
      List<MemoModel> progress =
          todos.where((element) => !element.isCompleted!).toList();
      List<MemoModel> completed =
          todos.where((element) => element.isCompleted!).toList();
      emit(state.copyWith(
          memolist: todos,
          filterlist: progress,
          completedlist: completed,
          loading: false));
      // print('memolist: ${state.memolist.length}');
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> _onRemoveMemo(RemoveMemo event, Emitter<MemoState> emit) async {
    try {
      await ApiService().deleteData(event.removeevent); //백엔드 데이터 삭제 수행
      final RemoveMemos = state.memolist.where((instance) {
        return instance.id != event.removeevent.id;
      }).toList();
      final filteredRemoveMemos = state.filterlist.where((element) {
        return element.id != event.removeevent.id && !element.isCompleted!;
      }).toList();
      final completedRemoveMemos = state.completedlist.where((element) {
        return element.id != event.removeevent.id && element.isCompleted!;
      }).toList();

      emit(state.copyWith(
          memolist: RemoveMemos,
          filterlist: filteredRemoveMemos,
          completedlist: completedRemoveMemos,
          loading: false));
    } catch (e) {
      // debugPrint('Error : $e');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onModifyMemo(ModifyMemo event, Emitter<MemoState> emit) async {
    try {
      await ApiService().updateData(event.modifyevent);

      List<MemoModel> filteredupdateTodos = state.filterlist.map((element) {
        return (element.id == event.modifyevent.id)
            ? event.modifyevent
            : element;
      }).toList();
      List<MemoModel> filterecompletedTodos =
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

  Future<void> _onAddMemo(AddMemo event, Emitter<MemoState> emit) async {
    try {
      final addedTodo = await ApiService().insertData(event.addevent);
      // final updateTodos = List<MemoModel>.from(state.memolist)..add(addedTodo);
      final filteredupdateTodos = List<MemoModel>.from(state.filterlist)
        ..add(addedTodo);
      emit(state.copyWith(filterlist: filteredupdateTodos));
    } catch (e) {
      // debugPrint('Error : $e');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onFilterMemo(FilterMemo event, Emitter<MemoState> emit) {
    final query = event.query; //MemoEvent>FilterMemo>query
    if (query.isEmpty) {
      emit(state.copyWith(
          filterlist: state.memolist, loading: false, error: ''));
      print('-empty list -');
    } else {
      final List<MemoModel> filtered =
          state.memolist.where((list) => _matchesQuery(list, query)).toList();
      // print('Filtered value : ${filtered.length}');
      emit(state.copyWith(
        filterlist: filtered,
        completedlist: filtered,
        loading: false,
        error: '',
      ));
    }
  }

  bool _matchesQuery(MemoModel list, String query) {
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
