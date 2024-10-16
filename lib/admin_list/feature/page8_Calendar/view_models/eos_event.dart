import 'package:oneline2/admin_list/feature/page7_EOS/models/eos_model.dart';

abstract class EOSEvent {}

class FetchEOS extends EOSEvent {}

class CompletedEOS extends EOSEvent {}

class AddEOS extends EOSEvent {
  final EOSModel addevent;
  AddEOS(this.addevent);
}

class RemoveEOS extends EOSEvent {
  final EOSModel removeevent;
  RemoveEOS(this.removeevent);
}

class ModifyEOS extends EOSEvent {
  final EOSModel modifyevent;
  ModifyEOS(this.modifyevent);
}

class FilterEOS extends EOSEvent {
  final String query;

  FilterEOS(this.query);
}

class selectSw extends EOSEvent {
  final String swname;
  selectSw(this.swname);
}
