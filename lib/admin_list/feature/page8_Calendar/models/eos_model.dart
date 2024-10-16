import 'package:intl/intl.dart';

class EOSModel {
  String? sw;
  String? version;
  DateTime? startdt;
  DateTime? enddt;
  String? code;
  String? memo;
  String? id;

  EOSModel({
    this.sw,
    this.version,
    this.startdt,
    this.enddt,
    this.code,
    this.memo,
    this.id,
  });

  factory EOSModel.fromJson(Map<String, dynamic> json) {
    if (json["sw"] == null) {
      throw Exception(' sw value null ');
    }
    return EOSModel(
        sw: json["sw"] ?? "sw",
        version: json["version"] ?? "version",
        startdt: DateTime.parse(json["startdt"]),
        enddt: DateTime.parse(json["enddt"]),
        code: json["code"] ?? "code",
        memo: json["memo"] ?? "memo",
        id: json["id"] ?? "id");
  }

  Map<String, dynamic> toJson() {
    return {
      "sw": sw,
      "version": version,
      "startdt": DateFormat('yyyy-MM-dd').format(startdt!),
      "enddt": DateFormat('yyyy-MM-dd').format(enddt!),
      "code": code,
      "memo": memo,
      "id": id
    };
  }
}
