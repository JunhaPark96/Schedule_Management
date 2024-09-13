import 'package:flutter/material.dart';

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
}
