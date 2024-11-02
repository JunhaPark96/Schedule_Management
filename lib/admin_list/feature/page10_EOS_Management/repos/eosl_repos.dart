import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_state.dart';

class ApiService {
  // TODO: 경준 대리님이 수정해야하는 부분 - baseURL
  final String baseUrl = 'http://52.78.12.208:5050';

  final String mockJsonPath =
      'assets/mock_data/eosl_detail_with_maintenance.json'; // 임시 데이터 생성
  final String maintenanceMockJsonPath =
      'assets/mock_data/maintenance_list.json'; // 유지보수 데이터 임시 경로
  final String eoslMockJsonPath =
      'assets/mock_data/eosl_list.json'; // EOSL 임시 데이터 경로

  // ---------------------------eosl_list page method start-------------------------------------
  // EOSL 리스트를 로드하는 메서드
  Future<List<EoslModel>> fetchEoslList() async {
    final Uri url = Uri.parse('$baseUrl/eosl-list');
    try {
      final response = await http.get(url);
      // print('EOSL List 주소: $url');

      if (response.statusCode == 200) {
        // JSON 응답을 파싱하여 객체로 처리
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        final List<dynamic> eoslList = jsonResponse['data'];

        return eoslList.map((eosl) => EoslModel.fromJson(eosl)).toList();
      } else {
        throw Exception('EOSL data 로드 실패!: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching EOSL List: $e');
      throw Exception('EOSL data 로드 실패: $e');
    }
  }

  // eosl 데이터 추가
  Future<void> insertEoslData(Map<String, dynamic> newData) async {
    final Uri url = Uri.parse('$baseUrl/eosl-list-insert');
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

  // EOSL 데이터 업데이트
  Future<void> updateEoslData(Map<String, dynamic> updatedData) async {
    final Uri url = Uri.parse('$baseUrl/eosl-list-update');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update EOSL data');
      }
    } catch (e) {
      throw Exception('Error updating EOSL data: $e');
    }
  }

  // EOSL 리스트 삭제
  Future<void> deleteEoslData(String eoslNo) async {
    final Uri url = Uri.parse('$baseUrl/eosl-list-delete/$eoslNo');
    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete EOSL data');
      }
    } catch (e) {
      throw Exception('Error deleting EOSL data: $e');
    }
  }

  // ---------------------------eosl_list page method end-------------------------------------

  // ---------------------------eosl_detail page method start-------------------------------------
  // EOSL 상세 리스트 로드
  Future<EoslDetailModel> fetchEoslDetail(
      String eoslNo, String hostName) async {
    final Uri url =
        Uri.parse('$baseUrl/eosl-list/eosl-detail/$eoslNo?hostname=$hostName');
    print('eosl_repos - EOSL Detail 주소: $url');
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

      final List<EoslDetailModel> eoslDetailList =
          (jsonResponse['eoslDetailList'] as List)
              .map((detail) => EoslDetailModel.fromJson(detail))
              .toList();

      // 첫 번째 항목을 선택하거나 조건에 맞는 항목을 필터링하여 선택
      final eoslDetail = eoslDetailList.firstWhere(
        (detail) => detail.hostName == hostName,
        orElse: () => EoslDetailModel(), // 없을 경우 빈 모델을 반환
      );

      final maintenanceList = (jsonResponse['maintenanceList'] as List)
          .map((m) => EoslMaintenance.fromJson(m))
          .where((maintenance) => maintenance.hostName == hostName)
          .toList();

      // 데이터 추출 결과 출력
      print('Extracted EoslDetail: $eoslDetail');
      print('Extracted Maintenances: $maintenanceList');

      return {
        'eoslDetail': eoslDetail,
        'maintenanceList': maintenanceList,
      };
    } catch (e) {
      print('Failed to load EOSL data: $e');
      throw Exception('Failed to load EOSL data: $e');
    }
  }

  // EOSL 유지보수 리스트를 로드하는 메서드 (로컬 -> 웹서버)
  Future<List<EoslMaintenance>> fetchEoslMaintenanceList(
      String hostName, String maintenanceNo) async {
    // 1. 로컬 JSON 파일에서 데이터 불러오기 시도
    try {
      final String response =
          await rootBundle.loadString(maintenanceMockJsonPath);
      final List<dynamic> maintenanceList = jsonDecode(response);

      // JSON 파일에서 유지보수 데이터를 파싱하여 반환
      return maintenanceList
          .map((maintenance) => EoslMaintenance.fromJson(maintenance))
          .toList();
    } catch (e) {
      print(
          'Failed to load local EOSL maintenance data: $e'); // 로컬 데이터 로드 실패 로그
    }

    // 2. 웹 서버에서 데이터 불러오기
    final Uri url = Uri.parse('$baseUrl/eosl-maintenance/$maintenanceNo');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> maintenanceList = jsonDecode(response.body);
        return maintenanceList
            .map((maintenance) => EoslMaintenance.fromJson(maintenance))
            .toList();
      } else {
        throw Exception(
            'Failed to load EOSL maintenance data: ${response.statusCode}');
      }
    } catch (e) {
      print(
          'Failed to load EOSL maintenance data from server: $e'); // 서버 데이터 로드 실패 로그
      throw Exception('Failed to load EOSL maintenance data: $e');
    }
  }

  // EOSL 유지보수 데이터를 추가하는 메서드
  Future<void> insertEoslMaintenanceData(
      Map<String, dynamic> newMaintenanceData) async {
    final Uri url = Uri.parse('$baseUrl/eosl-maintenance-insert');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newMaintenanceData),
      );

      if (response.statusCode == 200) {
        print('Successfully added new maintenance data.');
      } else {
        print('Failed to add new maintenance data: ${response.statusCode}');
        throw Exception(
            'Failed to add maintenance data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding maintenance data: $e');
      throw Exception('Error adding maintenance data: $e');
    }
  }

  // EOSL 유지보수 데이터를 업데이트하는 메서드
  Future<void> updateEoslMaintenanceData(
      String maintenanceNo, Map<String, dynamic> updatedMaintenanceData) async {
    final Uri url =
        Uri.parse('$baseUrl/eosl-maintenance-update/$maintenanceNo');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedMaintenanceData),
      );

      if (response.statusCode == 200) {
        print('Successfully updated maintenance data.');
      } else {
        print('Failed to update maintenance data: ${response.statusCode}');
        throw Exception(
            'Failed to update maintenance data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating maintenance data: $e');
      throw Exception('Error updating maintenance data: $e');
    }
  }

  // EOSL 유지보수 데이터를 삭제하는 메서드
  Future<void> deleteEoslMaintenanceData(String maintenanceNo) async {
    final Uri url =
        Uri.parse('$baseUrl/eosl-maintenance-delete/$maintenanceNo');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Successfully deleted maintenance data.');
      } else {
        print('Failed to delete maintenance data: ${response.statusCode}');
        throw Exception(
            'Failed to delete maintenance data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting maintenance data: $e');
      throw Exception('Error deleting maintenance data: $e');
    }
  }

  // ---------------------------eosl_detail page method end-------------------------------------

  // ---------------------------local eosl_list page method start-------------------------------------
  // 로컬 EOSL 리스트를 로드하는 메서드
  Future<List<EoslModel>> fetchLocalEoslList() async {
    try {
      final String response =
          await rootBundle.loadString('assets/mock_data/eosl_list.json');
      final List<dynamic> eoslList = jsonDecode(response);

      // 데이터가 비어 있는지 확인
      if (eoslList.isEmpty) {
        print('Local EOSL List is empty.');
      }

      return eoslList.map((eosl) => EoslModel.fromJson(eosl)).toList();
    } catch (e) {
      print('Error fetching Local EOSL List: $e');
      throw Exception('Local EOSL data 로드 실패: $e');
    }
  }

  // 로컬 JSON 파일에 데이터를 저장하는 메서드
  Future<void> _saveLocalEoslList(List<EoslModel> eoslList) async {
    final file = File(eoslMockJsonPath);
    final List<Map<String, dynamic>> jsonList =
        eoslList.map((eosl) => eosl.toJson()).toList();
    await file.writeAsString(jsonEncode({'data': jsonList}));
  }

  // 로컬 EOSL 데이터를 추가하는 메서드
  Future<void> insertLocalEoslData(EoslModel newEosl) async {
    try {
      final eoslList = await fetchLocalEoslList();
      eoslList.add(newEosl);
      await _saveLocalEoslList(eoslList);
      print('Successfully added new EOSL data to local file.');
    } catch (e) {
      print('Error adding EOSL data: $e');
      throw Exception('Error adding EOSL data: $e');
    }
  }

  // 로컬 EOSL 데이터를 업데이트하는 메서드
  Future<void> updateLocalEoslData(EoslModel updatedEosl) async {
    try {
      final eoslList = await fetchLocalEoslList();
      final index =
          eoslList.indexWhere((eosl) => eosl.eoslNo == updatedEosl.eoslNo);
      if (index != -1) {
        eoslList[index] = updatedEosl;
        await _saveLocalEoslList(eoslList);
        print('Successfully updated EOSL data in local file.');
      } else {
        throw Exception('Eosl data not found.');
      }
    } catch (e) {
      print('Error updating EOSL data: $e');
      throw Exception('Error updating EOSL data: $e');
    }
  }

  // 로컬 EOSL 데이터를 삭제하는 메서드
  Future<void> deleteLocalEoslData(String eoslNo) async {
    try {
      final eoslList = await fetchLocalEoslList();
      final updatedList =
          eoslList.where((eosl) => eosl.eoslNo != eoslNo).toList();
      await _saveLocalEoslList(updatedList);
      print('Successfully deleted EOSL data from local file.');
    } catch (e) {
      print('Error deleting EOSL data: $e');
      throw Exception('Error deleting EOSL data: $e');
    }
  }
}
