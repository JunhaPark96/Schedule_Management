//상태는 전체 그룹과 필터링 된 그룹을 모두 포함 하여 관리

import 'package:oneline2/admin_list/feature/page7_EOS/models/eos_model.dart';

class EOSState {
  final List<EOSModel> eoslist;
  final List<EOSModel> filterlist;
  String? selectedsw = 'sw';

  EOSState({
    required this.eoslist,
    this.selectedsw,
    required this.filterlist,
  });

  EOSState copyWith({
    List<EOSModel>? eoslist,
    List<EOSModel>? filterlist,
    String? selectedsw,
  }) {
    return EOSState(
      eoslist: eoslist ?? this.eoslist,
      filterlist: filterlist ?? this.filterlist,
      selectedsw: selectedsw ?? this.selectedsw,
    );
  }
}
