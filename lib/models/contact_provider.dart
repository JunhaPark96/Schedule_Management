import 'package:flutter/material.dart';
import 'package:oneline/models/contact_model.dart';

class ContactProvider with ChangeNotifier {
  final List<Contact> _contacts = [
    // 샘플 연락처 데이터 추가
    Contact(
        name: '김재영',
        phone: '010-1234-5678',
        email: 'abc123@google.com',
        workplace: '하나금융티아이',
        notes: '김재영 짱짱'),
    Contact(
        name: '박준하',
        phone: '010-2345-6789',
        email: 'abc456@google.com',
        workplace: '하나금융티아이',
        notes: '박준하 짱짱'),
    Contact(
        name: '김관중',
        phone: '010-3456-7890',
        email: 'abc789@google.com',
        workplace: '하나금융티아이',
        notes: '김관중 짱짱'),
  ];

  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void removeContact(Contact contact) {
    _contacts.remove(contact);
    notifyListeners();
  }
}
