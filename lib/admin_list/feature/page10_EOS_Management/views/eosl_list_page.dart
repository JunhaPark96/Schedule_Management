import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_state.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/views/eosl_detail.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/animated_search_bar.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EoslListPage extends StatefulWidget {
  const EoslListPage({super.key});

  @override
  State<EoslListPage> createState() => _EoslListPageState();
}

class _EoslListPageState extends State<EoslListPage> {
  bool isFolded = true;
  String searchTerm = '';
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    loadEoslDataIfNeeded(); // 초기 데이터 로드
  }

  void loadEoslDataIfNeeded() {
    final eoslBloc = context.read<EoslBloc>();
    eoslBloc.add(FetchEoslList()); // EOSL 리스트를 로드하는 이벤트 추가
  }

  void setFilterRows(String searchTerm) {
    final lowerCaseSearchTerm = searchTerm.toLowerCase();
    stateManager.setFilter((PlutoRow row) {
      return row.cells.values.any((cell) {
        final value = cell.value.toString().toLowerCase();
        return value.contains(lowerCaseSearchTerm);
      });
    });
    stateManager.notifyListeners(); // 필터링 후 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EOSL List'),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<EoslBloc, EoslState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.error.isNotEmpty) {
            return Center(
              child: Text('데이터 로드 중 오류 발생: ${state.error}'),
            );
          } else {
            rows = createRows(state.eoslList); // 상태에서 EOSL 리스트를 가져와서 행 생성
            return _buildEoslGrid();
          }
        },
      ),
    );
  }

  // 플루토 그리드 빌드 메서드
  Widget _buildEoslGrid() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: AnimatedSearchBar(
                  onSearch: (String searchTerm) {
                    setState(() {
                      this.searchTerm = searchTerm.toLowerCase();
                      setFilterRows(searchTerm);
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _showAddEoslDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: PlutoGrid(
              columns: createColumns(),
              rows: rows,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                stateManager = event.stateManager;
                setFilterRows(''); // Initialize filter to show all data
                if (stateManager.rows.isEmpty) {
                  print("PlutoGrid 내부 행이 없습니다.");
                } else {
                  print('PlutoGrid has ${stateManager.rows.length} rows.');
                }
              },
              onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                final row = event.row;
                final hostName = row.cells['host_name']?.value ?? '';
                // final eoslBloc = context.read<EoslBloc>();
                // 새로운 이벤트를 추가하여 hostName을 전달

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EoslDetailPage(hostName: hostName),
                  ),
                );
              },
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
                columnSize: PlutoGridColumnSizeConfig(
                  autoSizeMode: PlutoAutoSizeMode.scale,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 플루토 그리드의 열 생성 메서드
  List<PlutoColumn> createColumns() {
    return [
      PlutoColumn(
        title: '번호',
        field: 'eosl_no',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '호스트이름',
        field: 'host_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '업무명',
        field: 'business_name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'IP',
        field: 'ip_address',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: '플랫폼',
        field: 'platform',
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
        type: PlutoColumnType.text(),
        formatter: (dynamic value) {
          if (value == null || value.isEmpty) return ''; // 값이 없으면 빈 문자열 반환
          if (value.length == 8) {
            // 날짜 형식이 yyyymmdd인 경우
            return '${value.substring(0, 4)}-${value.substring(4, 6)}-${value.substring(6, 8)}';
          }
          return value; // 원래 값 반환
        },
      ),
    ];
  }

  // 플루토 그리드의 행 생성 메서드
  List<PlutoRow> createRows(List<EoslModel> eoslList) {
    print("createRows 메소드 호출 완료, 로드된 항목 수: ${eoslList.length}");

    return eoslList.map((server) {
      return PlutoRow(
        cells: {
          'eosl_no': PlutoCell(value: server.eoslNo),
          'host_name': PlutoCell(value: server.hostName ?? ''),
          'business_name': PlutoCell(value: server.businessName ?? ''),
          'ip_address': PlutoCell(value: server.ipAddress ?? ''),
          'platform': PlutoCell(value: server.platform ?? ''),
          'os_version': PlutoCell(value: server.osVersion ?? ''),
          'eosl_date': PlutoCell(value: server.eoslDate ?? ''),
        },
      );
    }).toList();
  }

  void _showAddEoslDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? eoslNo;
        String? hostName;
        String? businessName;
        String? ipAddress;
        String? platform;
        String? osVersion;
        String? eoslDate;

        return AlertDialog(
          title: const Text('Add New EOSL Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => eoslNo = value,
                  decoration: const InputDecoration(labelText: 'EOSL 번호'),
                ),
                TextField(
                  onChanged: (value) => hostName = value,
                  decoration: const InputDecoration(labelText: '호스트 이름'),
                ),
                TextField(
                  onChanged: (value) => businessName = value,
                  decoration: const InputDecoration(labelText: '업무 명'),
                ),
                TextField(
                  onChanged: (value) => ipAddress = value,
                  decoration: const InputDecoration(labelText: 'IP 주소'),
                ),
                TextField(
                  onChanged: (value) => platform = value,
                  decoration: const InputDecoration(labelText: '플랫폼'),
                ),
                TextField(
                  onChanged: (value) => osVersion = value,
                  decoration: const InputDecoration(labelText: 'OS 이름 및 버전'),
                ),
                TextField(
                  onChanged: (value) => eoslDate = value,
                  decoration:
                      const InputDecoration(labelText: 'EOSL 날짜 (yyyy-mm-dd)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // 모든 입력 필드가 채워졌는지 확인
                if ([
                  eoslNo,
                  hostName,
                  businessName,
                  ipAddress,
                  platform,
                  osVersion,
                  eoslDate
                ].every((element) => element != null && element.isNotEmpty)) {
                  // 새로운 데이터를 API로 추가
                  await context.read<EoslBloc>().apiService.addEoslData({
                    'eoslNo': eoslNo,
                    'hostName': hostName,
                    'businessName': businessName,
                    'ipAddress': ipAddress,
                    'platform': platform,
                    'osVersion': osVersion,
                    'eoslDate': eoslDate,
                  });
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  loadEoslDataIfNeeded(); // 데이터 새로고침
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
