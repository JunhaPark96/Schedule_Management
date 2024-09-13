import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/model/license_model.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/repos/license_repos.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/view_models/license_event.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/view_models/license_state.dart';
import '../lib/pluto_grid.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  LicenseBloc()
      : super(
          LicenseState(
            list: [],
            filterlist: [],
            prow: [],
          ),
        ) {
    on<FetchLicense>(_onFetchLicense);
    on<RemoveLicense>(_onRemoveLicense);
    on<AddLicense>(_onAddLicense);
    on<ModifyLicense>(_onModifyLicense);

    // on<FilterLicense>(_onFilterLicense); //event name
  }

  List<PlutoRow> convertModelToRows(List<LicenseModel> licenses) {
    return licenses.map((license) {
      return PlutoRow(
        cells: {
          'INDEX': PlutoCell(value: license.index),
          'ID': PlutoCell(value: license.id),
          '라이센스': PlutoCell(value: license.lname),
          '업무구분': PlutoCell(value: license.category),
          'HostName': PlutoCell(value: license.hostname),
          'IP': PlutoCell(value: license.ip),
          '등급': PlutoCell(value: license.rank),
          '보유': PlutoCell(value: license.cnt),
          'PL': PlutoCell(value: license.pl),
          'NUP RAC': PlutoCell(value: license.nuprac),
          'NUP': PlutoCell(value: license.nup),
          'RAC': PlutoCell(value: license.rac),
          'Version': PlutoCell(value: license.version),
          '만료일': PlutoCell(value: license.exp_date),
          'status': PlutoCell(value: 'saved'),
        },
      );
    }).toList();
  }

  void _onFetchLicense(FetchLicense event, Emitter<LicenseState> emit) async {
    try {
      List<LicenseModel> list = await ApiService().fetchData();
      List<PlutoRow> rowlist = convertModelToRows(list);

      emit(state.copyWith(list: list, filterlist: list, prow: rowlist));
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _onRemoveLicense(
      RemoveLicense event, Emitter<LicenseState> emit) async {
    try {
      await ApiService().deleteData(event.removeevent); //백엔드 데이터 삭제 수행
      final RemoveLicenses = state.list.where((instance) {
        return instance.id != event.removeevent.id;
      }).toList();
      List<PlutoRow> rowlist = convertModelToRows(RemoveLicenses);

      emit(state.copyWith(
        filterlist: RemoveLicenses,
        prow: rowlist,
      ));
    } catch (e) {
      // debugPrint('Error : $e');
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onModifyLicense(
      ModifyLicense event, Emitter<LicenseState> emit) async {
    try {
      await ApiService().updateData(event.modifyevent);

      List<LicenseModel> filteredupdateTodos = state.filterlist.map((element) {
        return (element.id == event.modifyevent.id)
            ? event.modifyevent
            : element;
      }).toList();

      emit(state.copyWith(
        filterlist: filteredupdateTodos,
      ));
      // print(event.modifyevent.isCompleted);
    } catch (e) {
      // debugPrint('Error : $e');
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onAddLicense(
      AddLicense event, Emitter<LicenseState> emit) async {
    try {
      final addedTodo = await ApiService().insertData(event.addevent);
      // final updateTodos = List<LicenseModel>.from(state.list)..add(addedTodo);
      final filteredupdateTodos = List<LicenseModel>.from(state.filterlist)
        ..add(addedTodo);
      List<PlutoRow> rowlist = convertModelToRows(filteredupdateTodos);

      emit(state.copyWith(prow: rowlist));
    } catch (e) {
      // debugPrint('Error : $e');
      // emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // void _onFilterLicense(FilterLicense event, Emitter<LicenseState> emit) {
  //   final query = event.query; //LicenseEvent>FilterLicense>query
  //   if (query.isEmpty) {
  //     emit(state.copyWith(
  //       filterlist: state.list,
  //     ));
  //     print('-empty list -');
  //   } else {
  //     final List<LicenseModel> filtered =
  //         state.list.where((list) => _matchesQuery(list, query)).toList();
  //     // print('Filtered value : ${filtered.length}');
  //     emit(state.copyWith(
  //       filterlist: filtered,
  //     ));
  //   }
  // }

  // bool _matchesQuery(LicenseModel list, String query) {
  //   String normalizedQuery = _normalize(query);
  //   // print(list.title!);
  //   return _normalize(list.lname!).contains(normalizedQuery);
  // }

  // String _normalize(String input) {
  //   return input
  //       .toLowerCase()
  //       .replaceAll(RegExp(r'[\s+]', multiLine: true), '');
  // }
}
