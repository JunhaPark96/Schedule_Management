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

    on<InsertEoslDetail>(_onInsertEoslDetail);
    // on<FetchEoslDetailList>(_onFetchEoslDetailList);
    on<FetchEoslMaintenanceList>(_onFetchEoslMaintenanceList);
    on<AddTaskToEoslDetail>(_onAddTaskToEoslDetail);
    on<FetchEoslDetail>(_onFetchEoslDetail);
  }

  // ---------------------------eosl_list page method start-------------------------------------
  // PlutoRow를 EoslModel로 변환하는 로직을 BLoC에서 관리
  void _onConvertPlutoRowToEoslModel(
      ConvertPlutoRowToEoslModel event, Emitter<EoslState> emit) {
    final EoslModel eoslModel = _getEoslModelFromRow(event.selectedRow);
    emit(state.copyWith(selectedEoslModel: eoslModel));
  }

  // PlutoRow에서 EoslModel로 변환하는 함수PO
  EoslModel _getEoslModelFromRow(PlutoRow row) {
    return EoslModel(
      eoslNo: row.cells['eosl_no']?.value,
      businessGroup: row.cells['business_group']?.value,
      businessName: row.cells['business_name']?.value,
      hostName: row.cells['hostname']?.value,
      ipAddress: row.cells['ip_address']?.value,
      platform: row.cells['platform']?.value,
      version: row.cells['version']?.value,
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
        field: 'hostname',
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
        field: 'version',
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
          'hostname': PlutoCell(value: server.hostName ?? ''),
          'ip_address': PlutoCell(value: server.ipAddress ?? ''),
          'platform': PlutoCell(value: server.platform ?? ''),
          'version': PlutoCell(value: server.version ?? ''),
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

      emit(state.copyWith(eoslList: updatedList, error: '', success: true));
    } catch (e) {
      emit(state.copyWith(error: '수정에 실패했습니다.', success: false));
    }
  }

  // Delete 이벤트 처리 로직
  Future<void> _onDeleteEosl(DeleteEosl event, Emitter<EoslState> emit) async {
    try {
      // emit(state.copyWith(loading: true, error: '')); // 로딩 상태 설정

      await apiService.deleteEoslData(event.eoslNo);

      // 상태 갱신
      final updatedList =
          state.eoslList.where((eosl) => eosl.eoslNo != event.eoslNo).toList();
      emit(
          state.copyWith(eoslList: updatedList, loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(
          loading: false, error: '삭제 중 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  // ---------------------------eosl_list page method end-------------------------------------

  Future<void> _onInsertEoslDetail(
      InsertEoslDetail event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      await apiService.insertEoslDetailData(event.newEoslDetail.toJson());

      // 삽입 후 상태 업데이트
      List<EoslDetailModel> updatedDetailList = List.from(state.eoslDetailList)
        ..add(event.newEoslDetail);

      emit(state.copyWith(eoslDetailList: updatedDetailList, loading: false));
    } catch (e) {
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

  // ---------------------------eosl_detail page method start-------------------------------------
  // Future<void> _onFetchEoslDetail(
  //     FetchEoslDetail event, Emitter<EoslState> emit) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: ''));
  //     final result =
  //         await apiService.fetchEoslDetailWithMaintenance(event.hostName);

  //     print('Fetched EoslDetail and Maintenance: $result'); // 데이터 로드 출력

  //     final eoslDetail = result['eoslDetail'] as EoslDetailModel; // 단일 객체 처리
  //     final List<EoslMaintenance> maintenanceList =
  //         result['maintenanceList'] as List<EoslMaintenance>;

  //     emit(state.copyWith(
  //       eoslDetailList: [eoslDetail], // 단일 객체를 리스트에 넣어 상태 유지
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
    final result = await apiService.fetchEoslDetailWithMaintenance(event.eoslNo, event.hostName);

    final List<EoslDetailModel> eoslDetailList = result['eoslDetail'] as List<EoslDetailModel>;
    final List<EoslMaintenance> maintenanceList = result['maintenanceList'] as List<EoslMaintenance>;

    emit(state.copyWith(
      eoslDetailList: eoslDetailList,
      eoslMaintenanceList: maintenanceList,
      loading: false,
    ));
  } catch (e) {
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
  // ---------------------------eosl_detail page method end-------------------------------------

  // ---------------------------eosl_history page method start-------------------------------------

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
              tag: event.tag,
              maintenanceDate: event.maintenanceDate,
              maintenanceTitle: event.maintenanceTitle,
              maintenanceContent: event.maintenanceContent));
      emit(state.copyWith(eoslMaintenanceList: [history], loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // 새로운 태스크를 추가하는 로직
  void _onAddTaskToEoslDetail(
      AddTaskToEoslDetail event, Emitter<EoslState> emit) {
    final List<EoslMaintenance> maintenanceList =
        List.from(state.eoslMaintenanceList);

    // 새 유지보수 번호 설정: 기존 리스트의 유지보수 번호에서 가장 큰 값을 가져와 1을 더함
    final newMaintenanceNo = (maintenanceList.isNotEmpty
            ? (int.tryParse(maintenanceList.map((m) => m.maintenanceNo).reduce(
                        (a, b) => int.parse(a) > int.parse(b) ? a : b)) ??
                    0) +
                1
            : 1)
        .toString();

    // 새로운 유지보수 내역 생성
    final newMaintenance = EoslMaintenance(
      maintenanceNo: newMaintenanceNo, // 새로 생성된 maintenanceNo
      hostName: event.hostName, // event에서 받은 hostName
      tag: event.tag, // event에서 받은 tag
      maintenanceDate: event.maintenanceDate, // 사용자 입력 날짜
      maintenanceTitle: event.maintenanceTitle, // 사용자 입력 제목
      maintenanceContent: event.maintenanceContent, // 사용자 입력 내용
    );

    // 새로 입력된 유지보수 내역을 리스트에 추가
    maintenanceList.add(newMaintenance);

    // 상태 업데이트
    emit(state.copyWith(eoslMaintenanceList: maintenanceList));
  }

  Future<void> _onInsertEoslMaintenance(
      InsertEoslMaintenance event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));

      // 서버에 새로운 유지보수 데이터를 전송
      await apiService.insertEoslMaintenanceData(event.newMaintenance.toJson());

      // 기존 유지보수 리스트에 새로 추가
      List<EoslMaintenance> updatedMaintenanceList =
          List.from(state.eoslMaintenanceList)..add(event.newMaintenance);

      emit(state.copyWith(
          eoslMaintenanceList: updatedMaintenanceList, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateEoslMaintenance(
      UpdateEoslMaintenance event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));

      // 서버에 유지보수 데이터 업데이트 요청
      await apiService.updateEoslMaintenanceData(
          event.maintenanceNo, event.updatedMaintenance.toJson());

      // 유지보수 리스트를 업데이트
      final updatedMaintenanceList =
          state.eoslMaintenanceList.map((maintenance) {
        return maintenance.maintenanceNo == event.maintenanceNo
            ? event.updatedMaintenance
            : maintenance;
      }).toList();

      emit(state.copyWith(
          eoslMaintenanceList: updatedMaintenanceList, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteEoslMaintenance(
      DeleteEoslMaintenance event, Emitter<EoslState> emit) async {
    try {
      emit(state.copyWith(loading: true, error: ''));

      // 서버에서 유지보수 데이터 삭제
      await apiService.deleteEoslMaintenanceData(event.maintenanceNo);

      // 삭제 후 유지보수 리스트 업데이트
      final updatedMaintenanceList = state.eoslMaintenanceList
          .where(
              (maintenance) => maintenance.maintenanceNo != event.maintenanceNo)
          .toList();

      emit(state.copyWith(
          eoslMaintenanceList: updatedMaintenanceList, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // ---------------------------eosl_history page method end-------------------------------------

  // ---------------------------local eosl_list page crud---------------------------
  // 로컬 데이터에 새 항목 추가하는 이벤트
  // Future<void> _onInsertEosl(InsertEosl event, Emitter<EoslState> emit) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: ''));

  //     // 로컬 데이터를 추가
  //     await apiService.insertLocalEoslData(event.newEosl);

  //     // 기존 데이터를 가져와서 새 데이터 추가 후 상태 갱신
  //     List<EoslModel> updatedList = List.from(state.eoslList)
  //       ..add(event.newEosl);
  //     emit(state.copyWith(eoslList: updatedList, loading: false));
  //   } catch (e) {
  //     emit(state.copyWith(loading: false, error: e.toString()));
  //   }
  // }

  // // 로컬 데이터를 업데이트하는 이벤트
  // Future<void> _onUpdateEosl(UpdateEosl event, Emitter<EoslState> emit) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: ''));

  //     // 로컬 데이터를 업데이트
  //     await apiService.updateLocalEoslData(event.updatedEosl);

  //     // 기존 리스트에서 업데이트할 항목을 찾아 갱신 후 상태 갱신
  //     final updatedList = state.eoslList.map((eosl) {
  //       return eosl.eoslNo == event.updatedEosl.eoslNo
  //           ? event.updatedEosl
  //           : eosl;
  //     }).toList();

  //     emit(state.copyWith(eoslList: updatedList, loading: false));
  //   } catch (e) {
  //     emit(state.copyWith(loading: false, error: e.toString()));
  //   }
  // }

  // // 로컬 데이터를 삭제하는 이벤트
  // Future<void> _onDeleteEosl(DeleteEosl event, Emitter<EoslState> emit) async {
  //   try {
  //     emit(state.copyWith(loading: true, error: ''));

  //     // 로컬 데이터를 삭제
  //     await apiService.deleteLocalEoslData(event.eoslNo);

  //     // 삭제 후 리스트를 갱신하고 상태 업데이트
  //     final updatedList =
  //         state.eoslList.where((eosl) => eosl.eoslNo != event.eoslNo).toList();

  //     emit(state.copyWith(eoslList: updatedList, loading: false));
  //   } catch (e) {
  //     emit(state.copyWith(loading: false, error: e.toString()));
  //   }
  // }
}
