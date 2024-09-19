class EoslMaintenance {
  final String maintenanceNo;
  final String hostName;
  final List<Map<String, dynamic>> tasks;

  EoslMaintenance({
    required this.maintenanceNo,
    required this.hostName,
    required this.tasks,
  });

  // JSON 데이터를 EoslMaintenance 객체로 변환하는 팩토리 생성자
  factory EoslMaintenance.fromJson(Map<String, dynamic> json) {
    return EoslMaintenance(
      maintenanceNo: json['maintenanceNo'] ?? '', // null-safe 처리
      hostName: json['hostName'] ?? '', // null-safe 처리
      tasks: List<Map<String, dynamic>>.from(
        (json['tasks'] ?? []).map((task) => Map<String, dynamic>.from(task)),
      ),
    );
  }

  // EoslMaintenance 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'maintenanceNo': maintenanceNo,
      'hostName': hostName,
      'tasks': tasks,
    };
  }
}
