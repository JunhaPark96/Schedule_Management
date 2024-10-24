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
      eoslNo: json['eoslNo'],
      hostName: json['hostName'],
      businessName: json['businessName'],
      ipAddress: json['ipAddress'],
      platform: json['platform'],
      version: json['version'],
      eoslDate: json['eoslDate'],
      businessGroup: json['businessGroup'],
      tag: json['tag'],
      isEosl: json['isEosl'],
    );
  }

  // EoslModel 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'eoslNo': eoslNo,
      'hostName': hostName,
      'businessName': businessName,
      'ipAddress': ipAddress,
      'platform': platform,
      'version': version,
      'eoslDate': eoslDate,
      'businessGroup': businessGroup,
      'tag': tag,
      'isEosl': isEosl,
    };
  }
}
