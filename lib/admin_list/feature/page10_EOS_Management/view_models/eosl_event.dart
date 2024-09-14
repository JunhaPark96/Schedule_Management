abstract class EoslEvent {}

class FetchEoslList extends EoslEvent {}

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
