import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

abstract class EoslEvent {}

class FetchEoslList extends EoslEvent {}

class FetchLocalEoslList extends EoslEvent {} // 로컬 데이터 가져오는 이벤트 추가

// eosl_event.dart
class ConvertPlutoRowToEoslModel extends EoslEvent {
  final PlutoRow selectedRow;
  ConvertPlutoRowToEoslModel(this.selectedRow);
}

// insert 이벤트 추가
class InsertEosl extends EoslEvent {
  final EoslModel newEosl;
  InsertEosl(this.newEosl);
}

// Update 이벤트 추가
class UpdateEosl extends EoslEvent {
  final EoslModel updatedEosl;
  UpdateEosl(this.updatedEosl);
}

// Delete 이벤트 추가
class DeleteEosl extends EoslEvent {
  final String eoslNo;
  DeleteEosl(this.eoslNo);
}


class FetchEoslDetailList extends EoslEvent {}

class FetchEoslDetail extends EoslEvent {
  final String hostName;
  FetchEoslDetail(this.hostName);
}

class FetchEoslMaintenanceList extends EoslEvent {
  final String hostName;
  final String maintenanceNo;

  FetchEoslMaintenanceList(this.hostName, this.maintenanceNo);
}

class AddTaskToEoslDetail extends EoslEvent {
  final String hostName;
  final Map<String, String> task;

  AddTaskToEoslDetail(this.hostName, this.task);
}

class FetchEoslHistory extends EoslEvent {
  final String hostName;
  final String maintenanceNo;

  FetchEoslHistory(this.hostName, this.maintenanceNo);
}
