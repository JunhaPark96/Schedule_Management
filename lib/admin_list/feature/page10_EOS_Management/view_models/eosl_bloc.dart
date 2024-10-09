import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/repos/eosl_repos.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'eosl_event.dart';
import 'eosl_state.dart';

class EoslBloc extends Bloc<EoslEvent, EoslState> {
  final ApiService apiService = ApiService(); // ApiService 인스턴스 생성

  EoslBloc()
      : super(EoslState(
          eoslList: [],
          columns: [],
          eoslDetailList: [],
          eoslMaintenanceList: [],
          loading: true,
        )) {
    on<FetchEoslList>(_onFetchEoslList);
    on<FetchLocalEoslList>(_onFetchLocalEoslList);
    on<ConvertPlutoRowToEoslModel>(_onConvertPlutoRowToEoslModel);
    on<InsertEosl>(_onInsertEosl);
    on<UpdateEosl>(_onUpdateEosl);
    on<DeleteEosl>(_onDeleteEosl);
    // on<FetchEoslDetailList>(_onFetchEoslDetailList);
    on<FetchEoslMaintenanceList>(_onFetchEoslMaintenanceList);
    on<AddTaskToEoslDetail>(_onAddTaskToEoslDetail);
    on<FetchEoslDetail>(_onFetchEoslDetail);
  }

  // PlutoRow를 EoslModel로 변환하는 로직을 BLoC에서 관리
  void _onConvertPlutoRowToEoslModel(
      ConvertPlutoRowToEoslModel event, Emitter<EoslState> emit) {
    final EoslModel eoslModel = _getEoslModelFromRow(event.selectedRow);
    emit(state.copyWith(selectedEoslModel: eoslModel));
  }

  // PlutoRow에서 EoslModel로 변환하는 함수
  EoslModel _getEoslModelFromRow(PlutoRow row) {
    return EoslModel(
      eoslNo: row.cells['eosl_no']?.value,
      businessGroup: row.cells['business_group']?.value,
      businessName: row.cells['business_name']?.value,
      hostName: row.cells['host_name']?.value,
      ipAddress: row.cells['ip_address']?.value,
      platform: row.cells['platform']?.value,
      osVersion: row.cells['os_version']?.value,
      eoslDate: row.cells['eosl_date']?.value,
      isEosl: row.cells['is_eosl']?.value == 'EOSL',
      tag: row.cells['tag']?.value,
    );
  }

  List<PlutoColumn> createColumns() {
    return [
      PlutoColumn(
        title: '업무 그룹',
        field: 'business_group',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '업무명',
        field: 'business_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '호스트이름',
        field: 'host_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'IP',
        field: 'ip_address',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '플랫폼',
        field: 'platform',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '버전',
        field: 'os_version',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'EOSL 날짜',
        field: 'eosl_date',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'EOSL 여부',
        field: 'is_eosl',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '태그',
        field: 'tag',
        type: PlutoColumnType.text(),
      ),
    ];
  }

  List<PlutoRow> createRows(List<EoslModel> eoslList) {
    return eoslList.map((server) {
      return PlutoRow(
        cells: {
          'eosl_no': PlutoCell(value: server.eoslNo ?? ''),
          'business_group': PlutoCell(value: server.businessGroup ?? ''),
          'business_name': PlutoCell(value: server.businessName ?? ''),
          'host_name': PlutoCell(value: server.hostName ?? ''),
          'ip_address': PlutoCell(value: server.ipAddress ?? ''),
          'platform': PlutoCell(value: server.platform ?? ''),
          'os_version': PlutoCell(value: server.osVersion ?? ''),
          'eosl_date': PlutoCell(value: server.eoslDate ?? ''),
          'is_eosl': PlutoCell(value: server.isEosl == true ? 'EOSL' : 'No'),
          'tag': PlutoCell(value: server.tag ?? ''),
        },
      );
    }).toList();
  }

  Future<void> _onFetchEoslList(
      FetchEoslList event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<EoslModel> eoslList = await apiService.fetchEoslList();
      List<PlutoColumn> columns = createColumns();
      emit(
          state.copyWith(eoslList: eoslList, columns: columns, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchLocalEoslList(
      FetchLocalEoslList event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      List<EoslModel> eoslList = await apiService.fetchLocalEoslList();
      print('Fetched Local EOSL List: ${eoslList.length} items');

      // columns가 제대로 생성되고 있는지 확인
      List<PlutoColumn> columns = createColumns();

      emit(
          state.copyWith(eoslList: eoslList, columns: columns, loading: false));
    } catch (e) {
      print('Error fetching Local EOSL List: $e');
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onInsertEosl(InsertEosl event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));

      // API로 새 데이터 전송
      await apiService.insertEoslData(event.newEosl.toJson());

      // 추가한 데이터 포함하여 리스트를 새로고침
      List<EoslModel> updatedList = List.from(state.eoslList)
        ..add(event.newEosl);

      emit(state.copyWith(eoslList: updatedList, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateEosl(UpdateEosl event, Emitter<EoslState> emit) async {
    try {
      await apiService.updateEoslData(event.updatedEosl.toJson());

      // 상태 갱신
      final updatedList = state.eoslList.map((eosl) {
        return eosl.eoslNo == event.updatedEosl.eoslNo
            ? event.updatedEosl
            : eosl;
      }).toList();

      emit(state.copyWith(eoslList: updatedList));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Delete 이벤트 처리 로직
  Future<void> _onDeleteEosl(DeleteEosl event, Emitter<EoslState> emit) async {
    try {
      await apiService.deleteEoslData(event.eoslNo);

      // 상태 갱신
      final updatedList =
          state.eoslList.where((eosl) => eosl.eoslNo != event.eoslNo).toList();

      emit(state.copyWith(eoslList: updatedList));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
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

  // Future<void> _onFetchEoslDetail(
  //     FetchEoslDetail event, Emitter<EoslState> emit) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: ''));
  //     final result =
  //         await apiService.fetchEoslDetailWithMaintenance(event.hostName);

  //     print('Fetched EoslDetail and Maintenance: $result'); // 데이터 로드 출력

  //     final eoslDetail = result['eoslDetail'] as EoslDetailModel;
  //     final maintenanceList = result['maintenances'] as List<EoslMaintenance>;

  //     emit(state.copyWith(
  //       eoslDetailList: [eoslDetail],
  //       eoslMaintenanceList: maintenanceList,
  //       loading: false,
  //     ));
  //   } catch (e) {
  //     print('Error fetching EoslDetail and Maintenance: $e'); // 에러 출력
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

      final eoslDetail = result['eoslDetail'] as EoslDetailModel; // 단일 객체 처리
      final List<EoslMaintenance> maintenanceList =
          result['maintenanceList'] as List<EoslMaintenance>;

      emit(state.copyWith(
        eoslDetailList: [eoslDetail], // 단일 객체를 리스트에 넣어 상태 유지
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
                maintenanceDate: event.maintenanceDate,
                tasks: [],
              ));
      emit(state.copyWith(eoslMaintenanceList: [history], loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // void _onAddTaskToEoslDetail(
  //     AddTaskToEoslDetail event, Emitter<EoslState> emit) {
  //   final maintenance = state.eoslMaintenanceList.firstWhere(
  //     (item) => item.hostName == event.hostName,
  //     orElse: () => EoslMaintenance(
  //       maintenanceNo: 'new_maintenance_no',
  //       hostName: event.hostName,
  //       tasks: [],
  //     ),
  //   );

  //   maintenance.tasks.add(event.task);
  //   List<EoslMaintenance> updatedList = List.from(state.eoslMaintenanceList)
  //     ..add(maintenance);
  //   emit(state.copyWith(eoslMaintenanceList: updatedList));
  // }
  // 새로운 태스크를 추가하는 로직
  void _onAddTaskToEoslDetail(
      AddTaskToEoslDetail event, Emitter<EoslState> emit) {
    final List<EoslMaintenance> maintenanceList = List.from(state.eoslMaintenanceList);
    
    final existingMaintenance = maintenanceList.firstWhere(
      (maintenance) => maintenance.hostName == event.hostName,
      orElse: () => EoslMaintenance(
        maintenanceNo: '1',
        hostName: event.hostName,
        maintenanceDate: event.maintenanceDate,
        tasks: [],
      ),
    );

    if (existingMaintenance.tasks.isEmpty) {
      maintenanceList.add(existingMaintenance);
    }

    // 태스크 추가
    existingMaintenance.tasks.add(event.task);

    // 새로운 태스크 저장
    emit(state.copyWith(eoslMaintenanceList: maintenanceList));

    // JSON에 저장하는 로직
    // apiService.saveTaskToLocalFile(maintenanceList);
  }
}
