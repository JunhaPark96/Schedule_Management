import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/repos/eosl_repos.dart';
import 'eosl_event.dart';
import 'eosl_state.dart';

class EoslBloc extends Bloc<EoslEvent, EoslState> {
  final ApiService apiService = ApiService(); // ApiService 인스턴스 생성

  EoslBloc()
      : super(EoslState(
          eoslList: [],
          eoslDetailList: [],
          eoslMaintenanceList: [],
          loading: true,
        )) {
    on<FetchEoslList>(_onFetchEoslList);
    on<FetchLocalEoslList>(_onFetchLocalEoslList);
    // on<FetchEoslDetailList>(_onFetchEoslDetailList);
    on<FetchEoslMaintenanceList>(_onFetchEoslMaintenanceList);
    on<AddTaskToEoslDetail>(_onAddTaskToEoslDetail);
    on<FetchEoslDetail>(_onFetchEoslDetail);
  }

  Future<void> _onFetchEoslList(
      FetchEoslList event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<EoslModel> eoslList = await apiService.fetchEoslList();
      emit(state.copyWith(eoslList: eoslList, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchLocalEoslList(
      FetchLocalEoslList event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<EoslModel> eoslList = await apiService.fetchLocalEoslList();
      print(
          'Fetched Local EOSL List: ${eoslList.length} items'); // 로컬 데이터 로드 확인
      emit(state.copyWith(eoslList: eoslList, loading: false));
    } catch (e) {
      print('Error fetching Local EOSL List: $e'); // 에러 로그
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // Future<void> _onFetchEoslDetailList(
  //     FetchEoslDetailList event, Emitter<EoslState> emit) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: ''));
  //     List<EoslDetailModel> detailList = await apiService.fetchEoslDetailList();
  //     emit(state.copyWith(eoslDetailList: detailList, loading: false));
  //   } catch (e) {
  //     emit(state.copyWith(loading: false, error: e.toString()));
  //   }
  // }

  // Future<void> _onFetchEoslDetail(
  //     FetchEoslDetail event, Emitter<EoslState> emit) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: ''));
  //     EoslDetailModel detail = await apiService.fetchEoslDetail(event.hostName);
  //     emit(state.copyWith(eoslDetailList: [detail], loading: false));
  //   } catch (e) {
  //     emit(state.copyWith(loading: false, error: e.toString()));
  //   }
  // }

  Future<void> _onFetchEoslDetail(
      FetchEoslDetail event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      final result =
          await apiService.fetchEoslDetailWithMaintenance(event.hostName);

      print('Fetched EoslDetail and Maintenance: $result'); // 데이터 로드 출력

      final eoslDetail = result['eoslDetail'] as EoslDetailModel;
      final maintenanceList = result['maintenances'] as List<EoslMaintenance>;

      emit(state.copyWith(
        eoslDetailList: [eoslDetail],
        eoslMaintenanceList: maintenanceList,
        loading: false,
      ));
    } catch (e) {
      print('Error fetching EoslDetail and Maintenance: $e'); // 에러 출력
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchEoslMaintenanceList(
      FetchEoslMaintenanceList event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<EoslMaintenance> maintenanceList = await apiService
          .fetchEoslMaintenanceList(event.hostName, event.maintenanceNo);
      emit(
          state.copyWith(eoslMaintenanceList: maintenanceList, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchEoslHistory(
      FetchEoslHistory event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<EoslMaintenance> maintenanceList = await apiService
          .fetchEoslMaintenanceList(event.hostName, event.maintenanceNo);
      final history = maintenanceList.firstWhere(
          (maintenance) => maintenance.maintenanceNo == event.maintenanceNo,
          orElse: () => EoslMaintenance(
                maintenanceNo: '',
                hostName: event.hostName,
                tasks: [],
              ));
      emit(state.copyWith(eoslMaintenanceList: [history], loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onAddTaskToEoslDetail(
      AddTaskToEoslDetail event, Emitter<EoslState> emit) {
    final maintenance = state.eoslMaintenanceList.firstWhere(
      (item) => item.hostName == event.hostName,
      orElse: () => EoslMaintenance(
        maintenanceNo: 'new_maintenance_no',
        hostName: event.hostName,
        tasks: [],
      ),
    );

    maintenance.tasks.add(event.task);
    List<EoslMaintenance> updatedList = List.from(state.eoslMaintenanceList)
      ..add(maintenance);
    emit(state.copyWith(eoslMaintenanceList: updatedList));
  }
}
