import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
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

  // final String mockJsonPath =
  //     'assets/mock_data/eosl_detail_with_maintenance.json'; // 임시 데이터 생성
  // final String maintenanceMockJsonPath =
  //     'assets/mock_data/maintenance_list.json'; // 유지보수 데이터 임시 경로
  // final String eoslMockJsonPath =
  //     'assets/mock_data/eosl_list.json'; // EOSL 임시 데이터 경로
  final Logger logger = Logger();
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

  Future<void> insertEoslDetailData(Map<String, dynamic> newDetailData) async {
    final Uri url = Uri.parse('$baseUrl/eosl-detail-insert');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newDetailData),
      );

      if (response.statusCode == 200) {
        print('Successfully added new EOSL detail data.');
      } else {
        print('Failed to add new EOSL detail data: ${response.statusCode}');
        throw Exception(
            'Failed to add EOSL detail data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding EOSL detail data: $e');
      throw Exception('Error adding EOSL detail data: $e');
    }
  }

  // API에서 EoslDetail과 EoslMaintenance 데이터를 함께 가져오는 메서드
  Future<Map<String, dynamic>> fetchEoslDetailWithMaintenance(
      String tag, String hostName) async {
    final logger = Logger();
    final Uri url = Uri.parse(
        '$baseUrl/eosl-list/eosl-detail-list?hostname=$hostName&tag=$tag');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? [];

        if (data.isEmpty) {
          logger.i('No data found in response.');
          return {'eoslDetail': [], 'maintenanceList': []};
        }

        // 각 데이터를 분리하여 EoslDetailData와 MaintenanceData 리스트를 생성
        final List<EoslDetailModel> eoslDetailList = [];
        final List<EoslMaintenance> maintenanceList = [];

        for (var item in data) {
          final Map<String, dynamic> detail = item as Map<String, dynamic>;

          // `eoslDetailData`와 `maintenanceData` 조건에 맞게 데이터 분리
          final eoslDetailData = {
            'eosl_date': detail['eosl_date'],
            'tag': detail['tag'],
            'hostname': detail['hostname'],
            'note': detail['note'],
            'quantity': detail['quantity'],
            'supplier': detail['supplier'],
          };

          eoslDetailList.add(EoslDetailModel.fromJson(eoslDetailData));

          // `maintenanceData` 관련 정보만 필터링
          final maintenanceData = {
            'hostname': detail['hostname'],
            'tag': detail['tag'],
            'maintenance_content': detail['maintenance_content'],
            'maintenance_date': detail['maintenance_date'],
            'maintenance_no': detail['maintenance_no'],
            'maintenance_title': detail['maintenance_title'],
          };

          maintenanceList.add(EoslMaintenance.fromJson(maintenanceData));
        }

        // JSON 형식으로 로깅
        logger.i(
            'Parsed EoslDetailList as JSON: ${eoslDetailList.map((e) => e.toJson()).toList()}');
        logger.i(
            'Parsed MaintenanceList as JSON: ${maintenanceList.map((e) => e.toJson()).toList()}');

        return {
          'eoslDetail': eoslDetailList,
          'maintenanceList': maintenanceList,
        };
      } else {
        logger.e('Error: ${response.statusCode}, ${response.body}');
        throw Exception(
            'Failed to load EOSL detail data: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Failed to load EOSL detail data: $e');
      throw Exception('Failed to load EOSL detail data: $e');
    }
  }

  // Detail data 업데이트
  Future<void> updateEoslDetailData(
      Map<String, dynamic> updatedDetailData) async {
    final Uri url = Uri.parse('$baseUrl/eosl-detail-update');
    final logger = Logger();
    logger.i('Sending update request to $url with data: $updatedDetailData');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedDetailData),
      );

      if (response.statusCode == 200) {
        logger.i('Update successful. Response: ${response.body}');
      } else {
        logger.w(
            'Failed to update EOSL detail. Status code: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to update EOSL detail data');
      }
    } catch (e) {
      logger.e('Error updating EOSL detail data: $e');
      throw Exception('Error updating EOSL detail data: $e');
    }
  }

  // ---------------------------eosl_detail page method end-------------------------------------
  // ---------------------------eosl_maintenance page method start-------------------------------------

  // EOSL 유지보수 데이터를 추가하는 메서드
  Future<void> insertEoslMaintenanceData(
      Map<String, dynamic> newMaintenanceData) async {
    final logger = Logger(); // Logger instance 생성
    final Uri url = Uri.parse('$baseUrl/eosl-maintenance-insert');
    logger.i('Sending POST request to $url with data: $newMaintenanceData');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newMaintenanceData),
      );

      if (response.statusCode == 200) {
        logger.i('Successfully added new maintenance data.');
      } else {
        logger.w('Failed to add new maintenance data: ${response.statusCode}');
        throw Exception(
            'Failed to add maintenance data: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error adding maintenance data: $e');
      throw Exception('Error adding maintenance data: $e');
    }
  }

  // EOSL 유지보수 데이터를 업데이트하는 메서드
  Future<void> updateEoslMaintenanceData(
      Map<String, dynamic> updatedMaintenanceData) async {
    final Uri url = Uri.parse('$baseUrl/eosl-maintenance-update');

    try {
      // 전송 전 데이터 로깅
      print(
          'Sending maintenance data for update: ${jsonEncode(updatedMaintenanceData)}');

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
    logger.i(
        'Attempting to delete maintenance data with maintenanceNo: $maintenanceNo');
    logger.i('DELETE request URL: $url');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        logger.i(
            'Successfully deleted maintenance data with maintenanceNo: $maintenanceNo');
      } else {
        logger.w(
            'Failed to delete maintenance data. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to delete maintenance data: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error deleting maintenance data: $e');
      throw Exception('Error deleting maintenance data: $e');
    }
  }

  // ---------------------------eosl_maintenance page method end-------------------------------------

  // ---------------------------local eosl_list page method start-------------------------------------
  // 로컬 EOSL 리스트를 로드하는 메서드
  // Future<List<EoslModel>> fetchLocalEoslList() async {
  //   try {
  //     final String response =
  //         await rootBundle.loadString('assets/mock_data/eosl_list.json');
  //     final List<dynamic> eoslList = jsonDecode(response);

  //     // 데이터가 비어 있는지 확인
  //     if (eoslList.isEmpty) {
  //       print('Local EOSL List is empty.');
  //     }

  //     return eoslList.map((eosl) => EoslModel.fromJson(eosl)).toList();
  //   } catch (e) {
  //     print('Error fetching Local EOSL List: $e');
  //     throw Exception('Local EOSL data 로드 실패: $e');
  //   }
  // }

  // // 로컬 JSON 파일에 데이터를 저장하는 메서드
  // Future<void> _saveLocalEoslList(List<EoslModel> eoslList) async {
  //   final file = File(eoslMockJsonPath);
  //   final List<Map<String, dynamic>> jsonList =
  //       eoslList.map((eosl) => eosl.toJson()).toList();
  //   await file.writeAsString(jsonEncode({'data': jsonList}));
  // }

  // // 로컬 EOSL 데이터를 추가하는 메서드
  // Future<void> insertLocalEoslData(EoslModel newEosl) async {
  //   try {
  //     final eoslList = await fetchLocalEoslList();
  //     eoslList.add(newEosl);
  //     await _saveLocalEoslList(eoslList);
  //     print('Successfully added new EOSL data to local file.');
  //   } catch (e) {
  //     print('Error adding EOSL data: $e');
  //     throw Exception('Error adding EOSL data: $e');
  //   }
  // }

  // // 로컬 EOSL 데이터를 업데이트하는 메서드
  // Future<void> updateLocalEoslData(EoslModel updatedEosl) async {
  //   try {
  //     final eoslList = await fetchLocalEoslList();
  //     final index =
  //         eoslList.indexWhere((eosl) => eosl.eoslNo == updatedEosl.eoslNo);
  //     if (index != -1) {
  //       eoslList[index] = updatedEosl;
  //       await _saveLocalEoslList(eoslList);
  //       print('Successfully updated EOSL data in local file.');
  //     } else {
  //       throw Exception('Eosl data not found.');
  //     }
  //   } catch (e) {
  //     print('Error updating EOSL data: $e');
  //     throw Exception('Error updating EOSL data: $e');
  //   }
  // }

  // // 로컬 EOSL 데이터를 삭제하는 메서드
  // Future<void> deleteLocalEoslData(String eoslNo) async {
  //   try {
  //     final eoslList = await fetchLocalEoslList();
  //     final updatedList =
  //         eoslList.where((eosl) => eosl.eoslNo != eoslNo).toList();
  //     await _saveLocalEoslList(updatedList);
  //     print('Successfully deleted EOSL data from local file.');
  //   } catch (e) {
  //     print('Error deleting EOSL data: $e');
  //     throw Exception('Error deleting EOSL data: $e');
  //   }
  // }
}
