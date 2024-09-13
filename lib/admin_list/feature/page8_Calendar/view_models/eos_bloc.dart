import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/models/eos_model.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/view_models/eos_event.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/view_models/eos_state.dart';

import '../repos/eos_repos.dart';

class EOSBloc extends Bloc<EOSEvent, EOSState> {
  EOSBloc()
      : super(EOSState(
          eoslist: [],
          selectedsw: 'sw',
          filterlist: [],
        )) {
    on<FetchEOS>(_onFetchEOS);
    on<RemoveEOS>(_onRemoveEOS);
    on<AddEOS>(_onAddEOS);
    on<ModifyEOS>(_onModifyEOS);
    on<FilterEOS>(_onFilterEOS); //event name
    on<selectSw>(_onSwname);
  }

  void _onSwname(selectSw event, Emitter<EOSState> emit) async {
    try {
      emit(state.copyWith(selectedsw: event.swname));
    } catch (e) {
      print('Error : $e ');
    }
  }

  void _onFetchEOS(FetchEOS event, Emitter<EOSState> emit) async {
    try {
      List<EOSModel> eoslist = await ApiService().fetchData();

      emit(state.copyWith(
        eoslist: eoslist,
        filterlist: eoslist,
        selectedsw: eoslist.first.sw,
      ));
      print('eoslist: ${state.eoslist.length}');
      // print('filterlist: ${state.filterlist.length}');
    } catch (error) {
      // emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> _onRemoveEOS(RemoveEOS event, Emitter<EOSState> emit) async {
    try {
      await ApiService().deleteData(event.removeevent); //백엔드 데이터 삭제 수행
      final filteredRemoveEOSs = state.filterlist.where((element) {
        return element.sw != event.removeevent.sw;
      }).toList();

      emit(state.copyWith(filterlist: filteredRemoveEOSs));
    } catch (e) {
      print('Error : $e ');
    }
  }

  Future<void> _onModifyEOS(ModifyEOS event, Emitter<EOSState> emit) async {
    try {
      await ApiService().updateData(event.modifyevent);

      List<EOSModel> filteredupdateEOS = state.filterlist.map((element) {
        return (element.sw == event.modifyevent.sw)
            ? event.modifyevent
            : element;
      }).toList();

      emit(state.copyWith(
        filterlist: filteredupdateEOS,
      ));
    } catch (e) {
      print('Error : $e ');
    }
  }

  void _onAddEOS(AddEOS event, Emitter<EOSState> emit) async {
    try {
      final addedTodo = await ApiService().insertData(event.addevent);
      final filteredupdateEOS = List<EOSModel>.from(state.filterlist)
        ..add(addedTodo);
      emit(state.copyWith(filterlist: filteredupdateEOS));
    } catch (e) {
      print('Error : $e ');
    }
  }

  void _onFilterEOS(FilterEOS event, Emitter<EOSState> emit) {
    final query = event.query; //MemoEvent>FilterEOS>query

    if (query.isEmpty) {
      emit(state.copyWith(filterlist: state.eoslist));
      print('-empty list -');
    } else {
      final List<EOSModel> filtered =
          state.filterlist.where((list) => _matchesQuery(list, query)).toList();
      // print('Filtered value : ${filtered.length}');
      emit(state.copyWith(filterlist: filtered));
    }
  }

  bool _matchesQuery(EOSModel list, String query) {
    String normalizedQuery = _normalize(query);
    // print(list.title!);
    return _normalize(list.sw!).contains(normalizedQuery);
  }

  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[\s+]', multiLine: true), '');
  }
}
