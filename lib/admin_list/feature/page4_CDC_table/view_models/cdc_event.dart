import 'package:oneline2/admin_list/feature/page4_CDC_table/model/cdc_model.dart';

abstract class CdcEvent {}

class FetchCdc extends CdcEvent {}

class AddCdc extends CdcEvent {
  final CdcModel addevent;
  AddCdc(this.addevent);
}

class RemoveCdc extends CdcEvent {
  final CdcModel removeevent;
  RemoveCdc(this.removeevent);
}

class ModifyCdc extends CdcEvent {
  final CdcModel modifyevent;
  ModifyCdc(this.modifyevent);
}
