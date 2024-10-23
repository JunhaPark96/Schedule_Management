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
      hostName: json['hostName'] ?? '', // null-safe 처리
      field: json['field'] ?? '',
      quantity: json['quantity'] ?? '',
      note: json['note'] ?? '',
      supplier: json['supplier'] ?? '',
      eoslDate: json['eoslDate'] ?? '',
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
