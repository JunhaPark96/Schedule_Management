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
      hostName: json['hostname'] ?? '', // null-safe 처리
      field: json['field'] ?? '',
      quantity: json['quantity'] ?? '',
      note: json['note'] ?? '',
      supplier: json['supplier'] ?? '',
      eoslDate: json['eosl_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostname': hostName,
      'field': field,
      'quantity': quantity,
      'note': note,
      'supplier': supplier,
      'eosl_date': eoslDate,
    };
  }
}
