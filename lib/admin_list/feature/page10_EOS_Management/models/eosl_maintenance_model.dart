class EoslMaintenance {
  final String? maintenanceNo;
  final String? hostName;
  final String? tag;
  final String? maintenanceDate;
  final String? maintenanceTitle;
  final String? maintenanceContent;

  EoslMaintenance({
     this.maintenanceNo,
     this.hostName,
     this.tag,
     this.maintenanceDate,
     this.maintenanceTitle,
     this.maintenanceContent,
  });

  // JSON 데이터를 EoslMaintenance 객체로 변환하는 팩토리 생성자
  factory EoslMaintenance.fromJson(Map<String, dynamic> json) {
    return EoslMaintenance(
      maintenanceNo: json['maintenance_no'] ?? '',
      hostName: json['hostname'] ?? '',
      tag: json['tag'] ?? '',
      maintenanceDate: json['maintenance_date'] ?? '',
      maintenanceTitle: json['maintenance_title'] ?? '',
      maintenanceContent: json['maintenance_content'] ?? '',
    );
  }

  // EoslMaintenance 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'maintenanceNo': maintenanceNo,
      'hostname': hostName,
      'tag': tag,
      'maintenance_date': maintenanceDate,
      'maintenance_title': maintenanceTitle,
      'maintenance_content': maintenanceContent,
    };
  }
}
