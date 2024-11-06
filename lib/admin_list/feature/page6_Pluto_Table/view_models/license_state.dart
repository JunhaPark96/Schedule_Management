import 'package:oneline2/admin_list/feature/page6_Pluto_Table/lib/pluto_grid.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/model/license_model.dart';

class LicenseState {
  final List<LicenseModel> list;
  final List<LicenseModel> filterlist;

  final List<PlutoRow> prow;

  LicenseState({
    required this.list,
    required this.filterlist,
    required this.prow,
  });

  LicenseState copyWith({
    List<LicenseModel>? list,
    List<LicenseModel>? filterlist,
    List<PlutoRow>? prow,
  }) {
    return LicenseState(
      list: list ?? this.list,
      filterlist: filterlist ?? this.filterlist,
      prow: prow ?? this.prow,
    );
  }
}
