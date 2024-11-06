import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/contact_model.dart';

class ContactRepository {
  final String baseUrl = 'http://52.78.12.208:5050';
  final int _currentId = 0;

  final List<Contact> _contacts = [
    Contact(
      id: 0,
      name: '김철수',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: 'Supplier A',
      title: '주임',
      role: 'DB',
      memo: '김철수의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 1,
      name: '이영희',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '디포커스',
      title: '대리',
      role: 'DB',
      memo: '이영희의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 2,
      name: '박민수',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '바오밥테크놀로지',
      title: '과장',
      role: 'OA',
      memo: '박민수의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 3,
      name: '최수지',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '씨아이솔루션',
      title: '차장',
      role: '미들웨어',
      memo: '최수지의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 4,
      name: '정우성',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '마이더스AI',
      title: '부장',
      role: '네트워크/보안',
      memo: '정우성의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 5,
      name: '장동건',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '소만사',
      title: '매니저',
      role: '인프라 운영 총괄',
      memo: '장동건의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 6,
      name: '송혜교',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '한싹',
      title: '이사(영업)',
      role: '보안 운영 총괄',
      memo: '송혜교의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 7,
      name: '전지현',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '시큐에버',
      title: '주임',
      role: '서버',
      memo: '전지현의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 8,
      name: '김우빈',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '안랩',
      title: '대리',
      role: '정보보안 시스템',
      memo: '김우빈의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 9,
      name: '이정재',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '진앤현',
      title: '과장',
      role: '서버',
      memo: '이정재의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 10,
      name: '황정민',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '엔시큐어',
      title: '차장',
      role: 'DB',
      memo: '황정민의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 11,
      name: '하정우',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '에스지엔',
      title: '부장',
      role: 'OA',
      memo: '하정우의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 12,
      name: '공유',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '웨어밸리데이터',
      title: '매니저',
      role: '정보보안 시스템',
      memo: '공유의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 13,
      name: '유해진',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '가연아이앤씨',
      title: '이사(영업)',
      role: '대외영업',
      memo: '유해진의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 14,
      name: '조진웅',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '뱅크웨어글로벌',
      title: '주임',
      role: '미들웨어',
      memo: '조진웅의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 15,
      name: '김희애',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '인스웨이브',
      title: '대리',
      role: '미들웨어',
      memo: '김희애의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 16,
      name: '한지민',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '솔비렉',
      title: '과장',
      role: 'DB',
      memo: '한지민의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 17,
      name: '엄정화',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '티맥스소프트',
      title: '차장',
      role: '서비스 유지보수',
      memo: '엄정화의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 18,
      name: '신민아',
      phoneNumber: '01012345678',
      faxNumber: '0311234567',
      email: 'abc123@gmail.com',
      address: '서울시 강남구 역삼동 123-45',
      organization: '아즈소프트',
      title: '부장',
      role: '운영총괄',
      memo: '신민아의 메모',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 19,
      name: '김재영',
      phoneNumber: '010-1234-5678',
      faxNumber: '02-123-4567',
      email: 'abc123@google.com',
      address: '서울시 강남구',
      organization: 'supplier A',
      title: '사원',
      role: '개발자',
      memo: '김재영 짱짱',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 20,
      name: '박준하',
      phoneNumber: '010-2345-6789',
      faxNumber: '02-234-5678',
      email: 'abc456@google.com',
      address: '서울시 서초구',
      organization: 'supplier b',
      title: '사원',
      role: '디자이너',
      memo: '박준하 짱짱',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
    Contact(
      id: 21,
      name: '김관중',
      phoneNumber: '010-3456-7890',
      faxNumber: '02-345-6789',
      email: 'abc789@google.com',
      address: '서울시 종로구',
      organization: 'supplier B',
      title: '사원',
      role: 'PM',
      memo: '김관중 짱짱',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    ),
  ];

  // 모든 연락처 조회(Fetch)
  Future<List<Contact>> fetchContacts() async {
    final Uri url = Uri.parse('$baseUrl/contacts');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        final List<dynamic> contactList = jsonResponse['data'];
        return contactList.map((contact) => Contact.fromJson(contact)).toList();
      } else {
        throw Exception('서버 응답 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 응답 없음 또는 데이터 로드 실패: $e');
      throw Exception('데이터 로드 실패: $e');
    }
  }

  // 단일 연락처 조회
  Future<Contact> fetchContactById(int contactId) async {
    final Uri url = Uri.parse('$baseUrl/contact/$contactId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Contact.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('서버 응답 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('연락처 조회 실패: $e');
      throw Exception('연락처 조회 실패: $e');
    }
  }

/* Array를 이용한 기존의 Fetch */
//    Future<List<Contact>> fetchContacts() async {
//    await Future.delayed(const Duration(seconds: 1));
//    List<Map<String, dynamic>> jsonContacts = _contacts.map((contact) => contact.toJson()).toList();
//    List<Contact> contactsFromJson = jsonContacts.map((json) => Contact.fromJson(json)).toList();
//    return contactsFromJson;
//  }

  // 새로운 연락처 등록
  Future<void> addContact(Contact contact) async {
    final Uri url = Uri.parse('$baseUrl/contact');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contact.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('연락처 등록 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('연락처 등록 실패: $e');
      throw Exception('연락처 등록 실패: $e');
    }
  }

  /* Array를 이용한 기존의 Add */
  //Future<void> addContact(Contact contact) async {
  //   _contacts.add(contact.copyWith(id: ++_currentId));
  //}

  // 연락처 삭제
  Future<void> removeContact(int contactId) async {
    final Uri url = Uri.parse('$baseUrl/contact/$contactId');
    try {
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception('연락처 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('연락처 삭제 실패: $e');
      throw Exception('연락처 삭제 실패: $e');
    }
  }

  /* Array를 이용한 기존의 Remove */
  //Future<void> removeContact(Contact contact) async {
  //  _contacts.removeWhere((c) => c.id == contact.id);
  //}

  // 기존 연락처 수정
  Future<void> updateContact(Contact updatedContact) async {
    final Uri url = Uri.parse('$baseUrl/contact/${updatedContact.id}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedContact.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('연락처 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('연락처 수정 실패: $e');
      throw Exception('연락처 수정 실패: $e');
    }
  }

  /* Array를 이용한 기존의 Update */
  //Future<void> updateContact(Contact updatedContact) async {
  //  final index = _contacts.indexWhere((c) => c.id == updatedContact.id);
  //  if (index != -1) {
  //    _contacts[index] = updatedContact;
  //  }
  //}

  List<Map<String, dynamic>> contactsToJson() {
    return _contacts.map((contact) => contact.toJson()).toList();
  }
}
