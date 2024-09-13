import 'package:oneline2/admin_list/feature/Page5_Memo/models/memo_model.dart';

//상태는 전체 그룹과 필터링 된 그룹을 모두 포함 하여 관리

class MemoState {
  final List<MemoModel> memolist;
  final List<MemoModel> filterlist;
  final List<MemoModel> completedlist;
  final bool loading;
  final String error;
  MemoState({
    required this.loading,
    required this.memolist,
    required this.completedlist,
    this.error = '',
    required this.filterlist,
  });

  MemoState copyWith({
    List<MemoModel>? memolist,
    List<MemoModel>? filterlist,
    List<MemoModel>? completedlist,
    bool? loading,
    String? error,
  }) {
    return MemoState(
      memolist: memolist ?? this.memolist,
      filterlist: filterlist ?? this.filterlist,
      completedlist: completedlist ?? this.completedlist,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
