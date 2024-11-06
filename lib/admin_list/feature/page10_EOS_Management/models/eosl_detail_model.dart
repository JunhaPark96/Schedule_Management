class EoslDetailModel {
  final String? hostName; // 클래스 필드명은 camelCase
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
      hostName: json['hostname'] as String? ?? '', // JSON 키는 snake_case
      field: json['field'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      note: json['note'] as String? ?? '',
      supplier: json['supplier'] as String? ?? '',
      eoslDate: json['eosl_date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostname': hostName, // JSON 키와 클래스 필드명 매핑
      'field': field,
      'quantity': quantity,
      'note': note,
      'supplier': supplier,
      'eosl_date': eoslDate,
    };
  }

  @override
  String toString() {
    return 'EoslDetailModel(hostname: $hostName, field: $field, quantity: $quantity, note: $note, supplier: $supplier, eoslDate: $eoslDate)';
  }
}
