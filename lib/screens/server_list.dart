import 'package:flutter/material.dart';
import 'package:oneline/models/server_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server List'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        // PlutoGrid 패키지
        child: PlutoGrid(
          columns: _createColumns(),
          rows: _createRows(),
          onChanged: (PlutoGridOnChangedEvent event) {
            // 셀 필드 및 값 변경 변수
            final rowIdx = event.rowIdx;
            final field = event.column.field;
            final value = event.value;

            // 행 변경 업데이트
            if (rowIdx < serverData.length) {
              final server = serverData[rowIdx];
              final updatedServer = _updateServer(server, field, value);
              serverData[rowIdx] = updatedServer;
            }
          },
          onLoaded: (PlutoGridOnLoadedEvent event) {
            print(event);
          },
          // 스타일 변경
          configuration: const PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
              activatedColor: Colors.tealAccent,
              gridBorderColor: Colors.teal,
              gridBackgroundColor: Colors.white,
              columnTextStyle: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
              cellTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 필드 생성
  List<PlutoColumn> _createColumns() {
    return [
      PlutoColumn(
        title: '서비스그룹이름',
        field: 'service_group_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '망연계',
        field: 'network_connection',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '개발/운영',
        field: 'environment',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '담당부서',
        field: 'department',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '서버종류',
        field: 'server_type',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'OS종류',
        field: 'os_type',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '호스트이름',
        field: 'host_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '서비스이름',
        field: 'service_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'IP',
        field: 'ip',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '관리자계정',
        field: 'admin_account',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'OS이름 및 버전',
        field: 'os_version',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'EOSL날짜',
        field: 'eosl_date',
        type: PlutoColumnType.date(),
        // 날짜가 없을 경우
        formatter: (dynamic value) {
          return value == null ? '' : value.toString().split('T').first;
        },
      ),
    ];
  }

  // 셀 생성
  List<PlutoRow> _createRows() {
    return serverData.map((data) {
      return PlutoRow(
        cells: {
          'service_group_name': PlutoCell(value: data.serviceGroupName ?? ''),
          'network_connection': PlutoCell(value: data.networkConnection ?? ''),
          'environment': PlutoCell(value: data.environment ?? ''),
          'department': PlutoCell(value: data.department ?? ''),
          'server_type': PlutoCell(value: data.serverType ?? ''),
          'os_type': PlutoCell(value: data.osType ?? ''),
          'host_name': PlutoCell(value: data.hostName ?? ''),
          'service_name': PlutoCell(value: data.serviceName ?? ''),
          'ip': PlutoCell(value: data.ip ?? ''),
          'admin_account': PlutoCell(value: data.adminAccount ?? ''),
          'os_version': PlutoCell(value: data.osVersion ?? ''),
          'eosl_date': PlutoCell(
              value: data.eoslDate?.toIso8601String().split('T').first ?? ''),
        },
      );
    }).toList();
  }

  // 셀 값 업데이트
  ServerModel _updateServer(ServerModel server, String field, dynamic value) {
    return ServerModel(
      serviceGroupName:
          field == 'service_group_name' ? value : server.serviceGroupName,
      networkConnection:
          field == 'network_connection' ? value : server.networkConnection,
      environment: field == 'environment' ? value : server.environment,
      department: field == 'department' ? value : server.department,
      serverType: field == 'server_type' ? value : server.serverType,
      osType: field == 'os_type' ? value : server.osType,
      hostName: field == 'host_name' ? value : server.hostName,
      serviceName: field == 'service_name' ? value : server.serviceName,
      ip: field == 'ip' ? value : server.ip,
      adminAccount: field == 'admin_account' ? value : server.adminAccount,
      osVersion: field == 'os_version' ? value : server.osVersion,
      eoslDate: field == 'eosl_date' ? DateTime.parse(value) : server.eoslDate,
    );
  }
}

// dummy 데이터
List<ServerModel> serverData = [
  ServerModel(
    serviceGroupName: '문서보안',
    networkConnection: '내부',
    environment: '운영',
    department: '그룹ASP',
    serverType: '물리',
    osType: 'Linux',
    hostName: 'hncpapp01',
    serviceName: '문서보안 AP#1 캐피탈',
    ip: '10.140.100.105',
    adminAccount: 'hfgadmin',
    osVersion: 'RHEL 9.1',
    eoslDate: DateTime.parse('2024-12-31'),
  ),
  ServerModel(
    serviceGroupName: '문서보안',
    networkConnection: '내부',
    environment: '운영',
    department: '그룹ASP',
    serverType: 'P',
    osType: 'Linux',
    hostName: 'hncpapp01',
    serviceName: '문서보안 AP#1 캐피탈',
    ip: '10.140.100.105',
    adminAccount: 'hfgadmin',
    osVersion: 'RHEL 9.1',
    eoslDate: DateTime.parse('2024-12-31'),
  ),
];
