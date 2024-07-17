import 'package:flutter/material.dart';

class Contact {
  final String name;
  final String phone;
  final String email;
  final String workplace; // 20240716_김재영 : 연락처 내 직장정보 추가
  final String notes; // 20240716_김재영 : 연락처 내 메모 추가

  Contact({
    required this.name,
    required this.phone,
    required this.email,
    required this.workplace, // 20240716_김재영 : 연락처 내 직장정보 추가
    required this.notes, // 20240716_김재영 : 연락처 내 메모 추가
  });
}
