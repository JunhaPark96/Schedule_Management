// class EoslDetailModel {
//   final String? hostName;
//   final String? field; // 구분상세
//   final String? quantity;
//   final String? note; // 비고
//   final String? supplier;
//   final String? eoslDate;

//   EoslDetailModel({
//     this.hostName,
//     this.field,
//     this.quantity,
//     this.note,
//     this.supplier,
//     this.eoslDate,
//   });

//   // JSON 데이터를 EoslDetailModel 객체로 변환하는 팩토리 생성자
//   factory EoslDetailModel.fromJson(Map<String, dynamic> json) {
//     return EoslDetailModel(
//       hostName: json['hostName'],
//       field: json['field'],
//       quantity: json['quantity'],
//       note: json['note'],
//       supplier: json['supplier'],
//       eoslDate: json['eoslDate'],
//     );
//   }

//   // EoslDetailModel 객체를 JSON 형식으로 변환하는 메서드
//   Map<String, dynamic> toJson() {
//     return {
//       'hostName': hostName,
//       'field': field,
//       'quantity': quantity,
//       'note': note,
//       'supplier': supplier,
//       'eoslDate': eoslDate,
//     };
//   }
// }
class EoslDetailModel {
  final String? hostName;
  final String? field;
  final String? quantity;
  final String? note;
  final String? supplier;
  final String? eoslDate;

  EoslDetailModel({
    this.hostName,
    this.field,
    this.quantity,
    this.note,
    this.supplier,
    this.eoslDate,
  });

  factory EoslDetailModel.fromJson(Map<String, dynamic> json) {
    return EoslDetailModel(
      hostName: json['hostName'] as String?,
      field: json['field'] as String?,
      quantity: json['quantity'] as String?,
      note: json['note'] as String?,
      supplier: json['supplier'] as String?,
      eoslDate: json['eoslDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostName': hostName,
      'field': field,
      'quantity': quantity,
      'note': note,
      'supplier': supplier,
      'eoslDate': eoslDate,
    };
  }
}
