// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
// import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
// import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';

// class EoslProvider with ChangeNotifier {
//   final Map<String, EoslModel> eoslMap = {};
//   final Map<String, EoslDetailModel> eoslDetailList = {};
//   final List<EoslModel> eoslInstances = [];
//   final Map<String, EoslMaintenance> eoslMaintenanceList = {}; // 유지보수 이력 맵

//   Future<List<EoslModel>> getEoslList() async {
//     final eoslJsonData =
//         await rootBundle.loadString('lib/assets/eosl_list.json');
//     // TODO: 나중에 db가져오는 데이터 링크로 변경되어야 함

//     if (eoslJsonData.isNotEmpty) {
//       final List<dynamic> eoslList = jsonDecode(eoslJsonData);
//       for (var eosl in eoslList) {
//         final eoslModel = EoslModel.fromJson(eosl);
//         print('EoslProvider: 호스트네임은: ${eoslModel.hostName}');

//         eoslMap[eoslModel.hostName] = eoslModel; // 맵에 저장
//         eoslInstances.add(eoslModel);
//       }
//       notifyListeners();
//       return eoslInstances;
//     }
//     throw Error();
//   }

//   // eosl id로 EOSL 조회
//   EoslModel? getEoslByNo(String eoslNo) {
//     return eoslMap[eoslNo];
//   }

//   // hostName으로 EOSL 조회
//   EoslModel? getEoslByHostName(String hostName) {
//     final eoslModel = eoslMap[hostName.trim().toLowerCase()];
//     print(
//         'EoslProvider: 호스트네임 저장: ${eoslModel?.hostName.trim().toLowerCase()}');

//     print('EoslProvider: 호스트네임 조회: ${eoslMap[hostName]}');
//     // 로그 추가: 현재 저장된 hostNames 확인
//     print('EoslProvider: - 현재 저장된 호스트네임들: ${eoslMap.keys}');

//     return eoslModel;
//   }

//   // 모든 EOSL리스트 반환
//   Map<String, EoslModel> get getAllEoslList => eoslMap;

//   // EOSL 상세 정보 가져오기
//   Future<void> getEoslDetailList() async {
//     final eoslDetailJsonData =
//         await rootBundle.loadString('lib/assets/eosl_detail_list.json');

//     if (eoslDetailJsonData.isNotEmpty) {
//       final List<dynamic> eoslDetailDataList = jsonDecode(eoslDetailJsonData);
//       for (var detail in eoslDetailDataList) {
//         final eoslDetailModel = EoslDetailModel.fromJson(detail);

//         print(
//             'EoslProvider - 로드된 EoslDetailModel 호스트네임: ${eoslDetailModel.hostName}');

//         // hostName을 키로 사용하여 eoslDetailList에 저장
//         eoslDetailList[eoslDetailModel.hostName] = eoslDetailModel;
//       }
//       notifyListeners();
//     } else {
//       throw Error();
//     }
//   }

//   // hostName으로 EOSL 상세 정보 조회
//   EoslDetailModel? getEoslDetailByHostName(String hostName) {
//     final eoslDetailModel = eoslDetailList[hostName.trim().toLowerCase()];

//     // print('EoslProvider: 현재 저장된 상세 호스트네임들: ${eoslDetailList.keys}');

//     return eoslDetailModel;
//   }

//   // 모든 EOSL리스트 반환
//   Map<String, EoslDetailModel> get getAllDetailEoslList => eoslDetailList;

//   // 유지보수 이력 리스트 로드
//   Future<List<EoslMaintenance>> getEoslMaintenanceList() async {
//     final eoslMaintenanceJsonData =
//         await rootBundle.loadString('lib/assets/eosl_maintenance_list.json');
//     final List<EoslMaintenance> maintenanceData = [];

//     if (eoslMaintenanceJsonData.isNotEmpty) {
//       final List<dynamic> eoslMaintenanceDataList =
//           jsonDecode(eoslMaintenanceJsonData);
//       for (var maintenance in eoslMaintenanceDataList) {
//         final eoslMaintenanceModel = EoslMaintenance.fromJson(maintenance);
//         eoslMaintenanceList[eoslMaintenanceModel.hostName.toLowerCase()] =
//             eoslMaintenanceModel;
//         maintenanceData.add(eoslMaintenanceModel); // 리스트에 추가
//       }
//       notifyListeners();
//     } else {
//       throw Error();
//     }
//     return maintenanceData;
//   }

//   // hostName으로 EOSL 유지보수 이력 조회
//   EoslMaintenance? getEoslMaintenanceByHostName(String hostName) {
//     final maintenanceModel = eoslMaintenanceList[hostName.trim().toLowerCase()];
//     return maintenanceModel;
//   }

//   // 유지보수 이력 추가 메서드
//   void addTaskToDetail(String hostName, Map<String, String> task) {
//     // 유지보수 데이터가 존재하는지 확인
//     final maintenance = eoslMaintenanceList[hostName.trim().toLowerCase()];
//     if (maintenance != null) {
//       // 유지보수 이력이 존재하는 경우 Task 추가
//       maintenance.tasks.add(task);
//       notifyListeners();
//     } else {
//       // 유지보수 이력이 존재하지 않으면 새로 생성
//       eoslMaintenanceList[hostName.trim().toLowerCase()] = EoslMaintenance(
//         maintenanceNo: 'new_maintenance_no',
//         hostName: hostName,
//         tasks: [task],
//       );
//       notifyListeners();
//     }
//   }

//   // 모든 유지보수 이력 리스트 반환
//   Map<String, EoslMaintenance> get getAllEoslMaintenanceList =>
//       eoslMaintenanceList;

//   // hostName으로 EOSL 유지보수 이력 조회
//   List<EoslMaintenance> getEoslMaintenanceListByHostName(String hostName) {
//     // 호스트 이름과 일치하는 모든 유지보수 항목을 필터링하여 반환
//     return eoslMaintenanceList.values.where((maintenance) {
//       return maintenance.hostName.trim().toLowerCase() ==
//           hostName.trim().toLowerCase();
//     }).toList();
//   }
// }
