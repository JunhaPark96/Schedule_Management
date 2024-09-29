import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class EoslState {
  final List<EoslModel> eoslList;
  final List<PlutoColumn> columns; // columns 필드 추가
  final EoslModel? selectedEoslModel; // 선택된 EoslModel을 관리
  final List<EoslDetailModel> eoslDetailList;
  final List<EoslMaintenance> eoslMaintenanceList;
  final bool loading;
  final String error;

  EoslState({
    required this.eoslList,
    required this.columns, // 초기화 시 columns 필드 추가
    this.selectedEoslModel, // 기본값 null
    required this.eoslDetailList,
    required this.eoslMaintenanceList,
    this.loading = false,
    this.error = '',
  });

  EoslState copyWith({
    List<EoslModel>? eoslList,
    List<PlutoColumn>? columns, // columns 필드 복사
    EoslModel? selectedEoslModel,
    List<EoslDetailModel>? eoslDetailList,
    List<EoslMaintenance>? eoslMaintenanceList,
    bool? loading,
    String? error,
  }) {
    return EoslState(
      eoslList: eoslList ?? this.eoslList,
      columns: columns ?? this.columns, // 상태 변경 시 columns 갱신
      selectedEoslModel: selectedEoslModel ?? this.selectedEoslModel,
      eoslDetailList: eoslDetailList ?? this.eoslDetailList,
      eoslMaintenanceList: eoslMaintenanceList ?? this.eoslMaintenanceList,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
