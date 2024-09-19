import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';

class EoslState {
  final List<EoslModel> eoslList;
  final List<EoslDetailModel> eoslDetailList;
  final List<EoslMaintenance> eoslMaintenanceList;
  final bool loading;
  final String error;

  EoslState({
    required this.eoslList,
    required this.eoslDetailList,
    required this.eoslMaintenanceList,
    this.loading = false,
    this.error = '',
  });

  EoslState copyWith({
    List<EoslModel>? eoslList,
    List<EoslDetailModel>? eoslDetailList,
    List<EoslMaintenance>? eoslMaintenanceList,
    bool? loading,
    String? error,
  }) {
    return EoslState(
      eoslList: eoslList ?? this.eoslList,
      eoslDetailList: eoslDetailList ?? this.eoslDetailList,
      eoslMaintenanceList: eoslMaintenanceList ?? this.eoslMaintenanceList,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
