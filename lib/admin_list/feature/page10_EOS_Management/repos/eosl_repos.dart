import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class ApiService {
  final String baseUrl = 'http://52.78.12.208:5050';
  final String mockJsonPath =
      'assets/mock_data/eosl_detail_with_maintenance.json'; // 임시 데이터 생성
  final String maintenanceMockJsonPath = 'assets/mock_data/maintenance_list.json'; // 유지보수 데이터 임시 경로

  // EOSL 리스트를 로드하는 메서드
  Future<List<EoslModel>> fetchEoslList() async {
    final Uri url = Uri.parse('$baseUrl/eosl-list');
    try {
      final response = await http.get(url);
      // print('EOSL List 주소: $url');

      if (response.statusCode == 200) {
        // JSON 응답을 파싱하여 객체로 처리
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // 리스트가 포함된 키에 접근 (예: 'data' 키가 있다고 가정)
        final List<dynamic> eoslList = jsonResponse['data'];

        // print('eosl_repos: 불러온 EOSL List: ${eoslList.length}개');
        return eoslList.map((eosl) => EoslModel.fromJson(eosl)).toList();
      } else {
        // print('eosl_repos: EOSL List 로드 실패, status code: ${response.statusCode}');
        throw Exception('EOSL data 로드 실패!: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching EOSL List: $e');
      throw Exception('EOSL data 로드 실패: $e');
    }
  }

  // eosl 데이터 추가
  Future<void> addEoslData(Map<String, dynamic> newData) async {
    final Uri url =
        Uri.parse('$baseUrl/eosl-add'); // Assuming the endpoint is '/eosl-add'
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newData),
      );

      if (response.statusCode == 200) {
        print('Successfully added new EOSL data.');
      } else {
        print('Failed to add new EOSL data: ${response.statusCode}');
        throw Exception('Failed to add EOSL data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding EOSL data: $e');
      throw Exception('Error adding EOSL data: $e');
    }
  }

  // EOSL 상세 리스트 로드
  Future<EoslDetailModel> fetchEoslDetail(String hostName) async {
    final Uri url = Uri.parse('$baseUrl/eosl-list/eosl-detail/$hostName');
    print('EOSL Detail 주소: $url');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> eoslDetail = jsonDecode(response.body);
        return EoslDetailModel.fromJson(eoslDetail);
      } else {
        throw Exception(
            'Failed to load EOSL detail data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load EOSL detail data: $e');
    }
  }

  // EoslDetail과 EoslMaintenance 데이터를 함께 가져오는 메서드
  Future<Map<String, dynamic>> fetchEoslDetailWithMaintenance(
      String hostName) async {
    try {
      // 임시 로컬 JSON 파일 읽기
      final String response = await rootBundle.loadString(mockJsonPath);
      print('Loaded JSON from $mockJsonPath: $response'); // JSON 로드 확인

      final Map<String, dynamic> jsonResponse = jsonDecode(response);

      // JSON 파싱 결과 출력
      print('Parsed JSON: $jsonResponse');

      // EoslDetail과 EoslMaintenance 데이터를 추출
      final eoslDetail = EoslDetailModel.fromJson(jsonResponse['eoslDetail']);
      final maintenanceList = (jsonResponse['maintenances'] as List)
          .map((m) => EoslMaintenance.fromJson(m))
          .toList();

      // 데이터 추출 결과 출력
      print('Extracted EoslDetail: $eoslDetail');
      print('Extracted Maintenances: $maintenanceList');

      return {
        'eoslDetail': eoslDetail,
        'maintenances': maintenanceList,
      };
    } catch (e) {
      print('Failed to load EOSL data: $e'); // 에러 출력
      throw Exception('Failed to load EOSL data: $e');
    }
  }

  // EOSL 유지보수 리스트를 로드하는 메서드
  // Future<List<EoslMaintenance>> fetchEoslMaintenanceList() async {
  //   final Uri url = Uri.parse('$baseUrl/eosl_maintenance_list.json');
  //   // final Uri url = Uri.parse('$baseUrl/eosl-list/eosl-detail/$hostName/eosl-maintenance$maintenanceNo');
  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final List<dynamic> maintenanceList = jsonDecode(response.body);
  //       return maintenanceList
  //           .map((maintenance) => EoslMaintenance.fromJson(maintenance))
  //           .toList();
  //     } else {
  //       throw Exception(
  //           'Failed to load EOSL maintenance data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load EOSL maintenance data: $e');
  //   }
  // }

  // EOSL 유지보수 리스트를 로드하는 메서드 (로컬 -> 웹서버)
  Future<List<EoslMaintenance>> fetchEoslMaintenanceList(String hostName, String maintenanceNo) async {
    // 1. 로컬 JSON 파일에서 데이터 불러오기 시도
    try {
      final String response = await rootBundle.loadString(maintenanceMockJsonPath);
      final List<dynamic> maintenanceList = jsonDecode(response);

      // JSON 파일에서 유지보수 데이터를 파싱하여 반환
      return maintenanceList.map((maintenance) => EoslMaintenance.fromJson(maintenance)).toList();
    } catch (e) {
      print('Failed to load local EOSL maintenance data: $e'); // 로컬 데이터 로드 실패 로그
    }

    // 2. 웹 서버에서 데이터 불러오기
    final Uri url = Uri.parse('$baseUrl/eosl-list/eosl-detail/$hostName/eosl-maintenance/$maintenanceNo');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> maintenanceList = jsonDecode(response.body);
        return maintenanceList
            .map((maintenance) => EoslMaintenance.fromJson(maintenance))
            .toList();
      } else {
        throw Exception('Failed to load EOSL maintenance data: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load EOSL maintenance data from server: $e'); // 서버 데이터 로드 실패 로그
      throw Exception('Failed to load EOSL maintenance data: $e');
    }
  }
}
