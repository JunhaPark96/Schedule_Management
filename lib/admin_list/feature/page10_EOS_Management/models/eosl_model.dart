class EoslModel {
  final String? eoslNo;
  final String? hostName;
  final String? businessName;
  final String? ipAddress;
  final String? platform;
  final String? version;
  final String? eoslDate;
  final String? businessGroup;
  final String? tag;
  final bool? isEosl;

  EoslModel({
    this.eoslNo,
    this.hostName,
    this.businessName,
    this.ipAddress,
    this.platform,
    this.version,
    this.eoslDate,
    this.businessGroup,
    this.tag,
    this.isEosl,
  });

  // JSON 데이터를 EoslModel 객체로 변환하는 팩토리 생성자
  factory EoslModel.fromJson(Map<String, dynamic> json) {
    return EoslModel(
      eoslNo: json['eosl_no'],
      hostName: json['hostname'],
      businessName: json['business_name'],
      ipAddress: json['ip_address'],
      platform: json['platform'],
      version: json['version'],
      eoslDate: json['eosl_date'],
      businessGroup: json['business_group'],
      tag: json['tag'],
      isEosl: json['is_eosl'],
    );
  }

  // EoslModel 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'eosl_no': eoslNo,
      'hostname': hostName,
      'business_name': businessName,
      'ip_address': ipAddress,
      'platform': platform,
      'version': version,
      'eosl_date': eoslDate,
      'business_group': businessGroup,
      'tag': tag,
      'is_eosl': isEosl,
    };
  }
}
