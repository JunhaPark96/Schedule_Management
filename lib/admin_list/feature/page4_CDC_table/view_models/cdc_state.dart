import 'package:oneline2/admin_list/feature/page4_CDC_table/lib/pluto_grid.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/model/cdc_model.dart';

class CdcState {
  final List<CdcModel> list;

  final List<PlutoRow> prow;

  CdcState({
    required this.list,
    required this.prow,
  });

  CdcState copyWith({
    List<CdcModel>? list,
    List<PlutoRow>? prow,
  }) {
    return CdcState(
      list: list ?? this.list,
      prow: prow ?? this.prow,
    );
  }
}
