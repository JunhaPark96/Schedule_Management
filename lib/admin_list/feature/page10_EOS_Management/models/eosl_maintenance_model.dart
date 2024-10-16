
class EoslMaintenance {
  final String maintenanceNo;
  final String hostName;
  final String tag;
  final String maintenanceDate;
  final String maintenanceTitle;
  final String maintenanceContent;

  EoslMaintenance({
    required this.maintenanceNo,
    required this.hostName,
    required this.tag,
    required this.maintenanceDate,
    required this.maintenanceTitle,
    required this.maintenanceContent,
  });

  // JSON 데이터를 EoslMaintenance 객체로 변환하는 팩토리 생성자
  factory EoslMaintenance.fromJson(Map<String, dynamic> json) {
    return EoslMaintenance(
      maintenanceNo: json['maintenanceNo'] ?? '',
      hostName: json['hostName'] ?? '',
      tag: json['tag'] ?? '',
      maintenanceDate: json['maintenanceDate'] ?? '',
      maintenanceTitle: json['maintenanceTitle'] ?? '',
      maintenanceContent: json['maintenanceContent'] ?? '',
    );
  }

  // EoslMaintenance 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'maintenanceNo': maintenanceNo,
      'hostName': hostName,
      'tag': tag,
      'maintenanceDate': maintenanceDate,
      'maintenanceTitle': maintenanceTitle,
      'maintenanceContent': maintenanceContent,
    };
  }
}
