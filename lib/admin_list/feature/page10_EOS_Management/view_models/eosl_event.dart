import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
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

// ------------------------------------------------------------

class FetchEoslDetailList extends EoslEvent {}

class FetchEoslDetail extends EoslEvent {
  final String hostName;
  final String tag;
  FetchEoslDetail(this.hostName, this.tag);
}

class InsertEoslDetail extends EoslEvent {
  final EoslDetailModel newEoslDetail;
  InsertEoslDetail(this.newEoslDetail);
}

class UpdateEoslDetail extends EoslEvent {
  final EoslDetailModel updatedDetail;

  UpdateEoslDetail(this.updatedDetail);
}

class FetchEoslMaintenanceList extends EoslEvent {
  final String hostName;
  final String tag;
  final String maintenanceNo;

  FetchEoslMaintenanceList(this.hostName, this.tag, this.maintenanceNo);
}

class AddTaskToEoslDetail extends EoslEvent {
  final String maintenanceNo;
  final String hostName;
  final String tag;
  final String maintenanceDate;
  final String maintenanceTitle;
  final String maintenanceContent;

  AddTaskToEoslDetail(this.maintenanceNo, this.hostName, this.tag,
      this.maintenanceDate, this.maintenanceTitle, this.maintenanceContent);
}

class FetchEoslHistory extends EoslEvent {
  final String maintenanceNo;
  final String hostName;
  final String tag;
  final String maintenanceDate;
  final String maintenanceTitle;
  final String maintenanceContent;

  FetchEoslHistory(this.maintenanceNo, this.hostName, this.tag,
      this.maintenanceDate, this.maintenanceTitle, this.maintenanceContent);
}

// 유지보수 작업 등록 이벤트
class InsertEoslMaintenance extends EoslEvent {
  EoslMaintenance newMaintenance;
  InsertEoslMaintenance(this.newMaintenance);
}

// 유지보수 작업 업데이트 이벤트
class UpdateEoslMaintenance extends EoslEvent {
  final String maintenanceNo;
  final EoslMaintenance updatedMaintenance;
  UpdateEoslMaintenance(this.maintenanceNo, this.updatedMaintenance);
}

// 유지보수 작업 삭제 이벤트
class DeleteEoslMaintenance extends EoslEvent {
  final String maintenanceNo;
  DeleteEoslMaintenance(this.maintenanceNo);
}
