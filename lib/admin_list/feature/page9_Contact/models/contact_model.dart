class Contact {
  final int id;
  final String name;
  final String phoneNumber;
  final String faxNumber;
  final String email;
  final String address;
  final String organization;
  final String title;
  final String role;
  final String memo;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.faxNumber,
    required this.email,
    required this.address,
    required this.organization,
    required this.title,
    required this.role,
    required this.memo,
    required this.createdAt,
    required this.modifiedAt,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? faxNumber,
    String? email,
    String? address,
    String? organization,
    String? title,
    String? role,
    String? memo,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      faxNumber: faxNumber ?? this.faxNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      organization: organization ?? this.organization,
      title: title ?? this.title,
      role: role ?? this.role,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      faxNumber: json['fax_number'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      organization: json['organization'] ?? '',
      title: json['title'] ?? '',
      role: json['role'] ?? '',
      memo: json['memo'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      modifiedAt:
          DateTime.tryParse(json['modified_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'faxNumber': faxNumber,
      'email': email,
      'address': address,
      'organization': organization,
      'title': title,
      'role': role,
      'memo': memo,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }
}
