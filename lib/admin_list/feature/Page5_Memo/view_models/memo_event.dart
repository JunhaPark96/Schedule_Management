import 'package:oneline2/admin_list/feature/Page5_Memo/models/memo_model.dart';

abstract class MemoEvent {}

class FetchMemo extends MemoEvent {}

class CompletedMemo extends MemoEvent {}

class AddMemo extends MemoEvent {
  final MemoModel addevent;
  AddMemo(this.addevent);
}

class RemoveMemo extends MemoEvent {
  final MemoModel removeevent;
  RemoveMemo(this.removeevent);
}

class ModifyMemo extends MemoEvent {
  final MemoModel modifyevent;
  ModifyMemo(this.modifyevent);
}

class FilterMemo extends MemoEvent {
  final String query;

  FilterMemo(this.query);
}
