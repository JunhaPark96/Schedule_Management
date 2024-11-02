import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_state.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/text_field.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/views/add_event_page.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/views/eosl_detail.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/animated_search_bar.dart';

class EoslListPage extends StatefulWidget {
  const EoslListPage({super.key});

  @override
  State<EoslListPage> createState() => _EoslListPageState();
}

class _EoslListPageState extends State<EoslListPage> {
  PlutoRow? selectedRow;
  late PlutoGridStateManager stateManager;
  String searchTerm = '';
  bool showActionButtons = false;

  @override
  void initState() {
    super.initState();
    loadEoslData(); // 데이터 로드
  }

  // EOSL 리스트 데이터를 Bloc을 통해 로드
  void loadEoslData() {
    context.read<EoslBloc>().add(FetchEoslList());
  }

  // 로컬 데이터를 로드하는 함수
  void loadLocalEoslData() {
    context.read<EoslBloc>().add(FetchLocalEoslList());
  }

  // 검색어를 통해 필터링하는 함수
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

  // AddEventPage로 데이터를 전달하고 네비게이트하는 메서드
  // void _navigateToAddEventPage(BuildContext context, EoslModel eoslData) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const AddEventPage(), // 수정 없이 사용
  //       settings: RouteSettings(
  //         arguments: eoslData, // 전달할 eoslData
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EOSL List'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: loadLocalEoslData, // 로컬 데이터 로드 버튼
          ),
        ],
      ),
      body: Column(
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
                  onPressed: () => _showAddEoslDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<EoslBloc, EoslState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.error.isNotEmpty) {
                  return Center(child: Text('에러: ${state.error}'));
                } else if (state.eoslList.isEmpty) {
                  return const Center(child: Text('데이터 호출 실패'));
                } else {
                  return PlutoGrid(
                    columns: [
                      PlutoColumn(
                        title: '', // 빈 문자열로 제목 없앰
                        field: 'select',
                        type: PlutoColumnType.text(),
                        enableRowChecked: true, // 체크박스만 보이게 함
                        width: 40, // 체크박스 열의 너비 조정
                      ),
                      ...state.columns, // 나머지 열 추가
                    ],
                    rows: state.eoslList
                        .map((eosl) => PlutoRow(cells: {
                              'select': PlutoCell(value: ""), // 체크박스 초기 값
                              'eosl_no': PlutoCell(value: eosl.eoslNo ?? ''),
                              'business_group':
                                  PlutoCell(value: eosl.businessGroup ?? ''),
                              'business_name':
                                  PlutoCell(value: eosl.businessName ?? ''),
                              'hostname': PlutoCell(value: eosl.hostName ?? ''),
                              'ip_address':
                                  PlutoCell(value: eosl.ipAddress ?? ''),
                              'platform': PlutoCell(value: eosl.platform ?? ''),
                              'version': PlutoCell(value: eosl.version ?? ''),
                              'eosl_date':
                                  PlutoCell(value: eosl.eoslDate ?? ''),
                              'is_eosl': PlutoCell(
                                  value: eosl.isEosl == true ? 'EOSL' : 'No'),
                              'tag': PlutoCell(value: eosl.tag ?? ''),
                            }))
                        .toList(),
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      stateManager = event.stateManager;

                      // 행 선택 모드 설정
                      // stateManager.setSelectingMode(PlutoGridSelectingMode.row);

                      // 체크박스 또는 행이 선택될 때 배타적으로 하나의 행만 선택되도록 설정
                      stateManager.addListener(() {
                        final selectedRows =
                            stateManager.checkedRows; // 선택된 행을 가져옴

                        if (selectedRows.isNotEmpty) {
                          // 여러 개의 행이 선택되었을 경우 첫 번째 행을 제외하고 모두 해제
                          if (selectedRows.length > 1) {
                            for (var i = 0; i < selectedRows.length; i++) {
                              stateManager.setRowChecked(
                                  selectedRows[i], false);
                            }
                          }
                          // 마지막으로 선택된 행을 가져와 처리 (항상 하나만 남도록 설정)
                          final selectedRow = selectedRows.last;
                          // 최종 선택된 행을 가져와 처리
                          setState(() {
                            this.selectedRow = selectedRow;
                            showActionButtons = true; // 버튼 표시
                          });

                          // 선택된 행 정보 콘솔에 출력
                          print('Selected row: ${selectedRow.cells}');

                          context
                              .read<EoslBloc>()
                              .add(ConvertPlutoRowToEoslModel(selectedRow));
                        } else {
                          setState(() {
                            showActionButtons = false; // 체크된 행이 없으면 버튼 숨김
                          });
                        }
                      });
                    },
                    onChanged: (PlutoGridOnChangedEvent event) {
                      // 체크박스 선택 시 그 행을 BLoC에 전달
                      if (event.column.field == 'select') {
                        final selectedRow = event.row;

                        // 이전에 선택된 행 해제
                        if (stateManager.checkedRows.isNotEmpty) {
                          for (var row in stateManager.checkedRows) {
                            stateManager.setRowChecked(row, false);
                          }
                        }

                        // 현재 클릭된 행 선택
                        stateManager.setRowChecked(selectedRow, true);

                        // 선택된 행 BLOC에 전달
                        context.read<EoslBloc>().add(
                              ConvertPlutoRowToEoslModel(selectedRow),
                            );
                        // 선택된 행 정보 콘솔에 출력
                        print('Selected row: ${selectedRow.cells}');
                      }
                    },
                    onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                      // 행을 더블 클릭하면 해당 상세 페이지로 이동
                      final hostName =
                          event.row.cells['host_name']?.value ?? '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EoslDetailPage(hostName: hostName),
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
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showActionButtons
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedRow != null) {
                      _showUpdateModal(context, selectedRow!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('업데이트할 행을 선택하세요')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    '업데이트',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (selectedRow != null) {
                      _showDeleteModal(context, selectedRow!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('삭제할 행을 선택하세요')),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: Colors.red, width: 2), // 테두리 설정
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 둥근 테두리
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    '삭제',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }

  // 추가 모달을 표시하는 함수
  void _showAddEoslDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        String? businessGroup;
        String? hostName;
        String? businessName;
        String? ipAddress;
        String? platform;
        String? version;
        String? eoslDate;
        String selectedTag = '';
        bool isCustomTag = false;
        String customTag = ''; // 새로운 태그를 저장할 변수
        // 태그가 있는 것에서 선택 가능
        List<String> existingTags = context
            .read<EoslBloc>()
            .state
            .eoslList
            .map((eosl) => eosl.tag ?? '')
            .toSet()
            .toList();

        if (existingTags.isNotEmpty) {
          selectedTag = existingTags.first;
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('새로운 EOSL 등록'),
              backgroundColor: Colors.teal[50],
              content: Container(
                width: MediaQuery.of(context).size.width * 0.65,
                height: 550,
                // color: Colors.teal[50],
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 20, bottom: 50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldWidget(
                        label: '업무 그룹',
                        initialValue: businessGroup,
                        onChanged: (value) {
                          businessGroup = value;
                        },
                      ),
                      TextFieldWidget(
                        label: '업무 명',
                        initialValue: businessName,
                        onChanged: (value) {
                          businessName = value;
                        },
                      ),
                      TextFieldWidget(
                        label: '호스트 이름',
                        initialValue: hostName,
                        onChanged: (value) {
                          hostName = value;
                        },
                      ),
                      TextFieldWidget(
                        label: 'IP 주소',
                        initialValue: ipAddress,
                        onChanged: (value) {
                          ipAddress = value;
                        },
                      ),
                      TextFieldWidget(
                        label: '플랫폼',
                        initialValue: platform,
                        onChanged: (value) {
                          platform = value;
                        },
                      ),
                      TextFieldWidget(
                        label: '이름 및 버전',
                        initialValue: version,
                        onChanged: (value) {
                          version = value;
                        },
                      ),
                      TextFieldWidget(
                        label: 'EOSL 날짜 (yyyy-mm-dd)',
                        initialValue: eoslDate,
                        onChanged: (value) {
                          eoslDate = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: isCustomTag,
                            onChanged: (value) {
                              setState(() {
                                isCustomTag = value ?? false;
                              });
                            },
                          ),
                          const Text('Custom Tag'),
                        ],
                      ),
                      if (isCustomTag) ...[
                        TextFieldWidget(
                          label: 'New Tag',
                          initialValue: customTag,
                          onChanged: (value) {
                            customTag = value;
                          },
                        ),
                      ] else ...[
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: '태그'),
                          value: selectedTag,
                          items: existingTags.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTag = newValue!;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if ([
                      hostName,
                      businessName,
                      ipAddress,
                      platform,
                      version,
                      eoslDate,
                      businessGroup
                    ].every(
                        (element) => element != null && element.isNotEmpty)) {
                      final tagToSave = isCustomTag ? customTag : selectedTag;

                      final formattedEoslDate = eoslDate!.replaceAll('-', '');

                      final newData = {
                        'hostname': hostName,
                        'business_name': businessName,
                        'ip_address': ipAddress,
                        'platform': platform,
                        'version': version,
                        'eosl_date': formattedEoslDate,
                        'business_group': businessGroup,
                        'tag': tagToSave, // 선택된 태그 또는 새로 입력한 태그
                        'is_eosl': DateTime.parse(eoslDate!)
                            .isBefore(DateTime.now()), // EOSL 여부 계산
                      };

                      try {
                        // API를 통해 데이터를 삽입

                        await context
                            .read<EoslBloc>()
                            .apiService
                            .insertEoslData(newData);

                        Navigator.of(context).pop(); // 다이얼로그 닫기
                        // loadEoslData(); // 데이터 새로고침
                        loadEoslData();
                      } catch (e) {
                        // 에러 처리
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add data: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('모든 필드를 입력하세요.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // 버튼 배경색
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 둥근 테두리
                    ),
                    elevation: 5, // 그림자 효과
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Colors.teal, width: 2), // 테두리 설정
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 둥근 테두리
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 업데이트 모달을 표시하는 함수
  void _showUpdateModal(BuildContext context, PlutoRow row) {
    // 행의 기존 데이터를 추출
    String? businessGroup = row.cells['business_group']?.value;
    String? hostName = row.cells['hostname']?.value;
    String? businessName = row.cells['business_name']?.value;
    String? ipAddress = row.cells['ip_address']?.value;
    String? platform = row.cells['platform']?.value;
    String? version = row.cells['version']?.value;
    String? eoslDate = row.cells['eosl_date']?.value;
    bool? isEosl = row.cells['is_eosl']?.value == 'EOSL';
    String? tag = row.cells['tag']?.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.teal[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Update EOSL Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  label: '업무 그룹',
                  initialValue: businessGroup,
                  onChanged: (value) {
                    businessGroup = value;
                  },
                ),
                TextFieldWidget(
                  label: '호스트 이름',
                  initialValue: hostName,
                  onChanged: (value) {
                    hostName = value;
                  },
                ),
                TextFieldWidget(
                  label: '업무 명',
                  initialValue: businessName,
                  onChanged: (value) {
                    businessName = value;
                  },
                ),
                TextFieldWidget(
                  label: 'IP 주소',
                  initialValue: ipAddress,
                  onChanged: (value) {
                    ipAddress = value;
                  },
                ),
                TextFieldWidget(
                  label: '플랫폼',
                  initialValue: platform,
                  onChanged: (value) {
                    platform = value;
                  },
                ),
                TextFieldWidget(
                  label: 'OS 이름 및 버전',
                  initialValue: version,
                  onChanged: (value) {
                    version = value;
                  },
                ),
                TextFieldWidget(
                  label: 'EOSL 날짜 (yyyy-mm-dd)',
                  initialValue: eoslDate,
                  onChanged: (value) {
                    eoslDate = value;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<bool>(
                  value: isEosl,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('EOSL')),
                    DropdownMenuItem(value: false, child: Text('No')),
                  ],
                  onChanged: (value) {
                    isEosl = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'EOSL 여부',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  label: '태그',
                  initialValue: tag,
                  onChanged: (value) {
                    tag = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final updatedEosl = EoslModel(
                      eoslNo: row.cells['eosl_no']?.value, // eoslNo는 변경 불가
                      businessGroup: businessGroup,
                      hostName: hostName,
                      businessName: businessName,
                      ipAddress: ipAddress,
                      platform: platform,
                      version: version,
                      eoslDate: eoslDate,
                      isEosl: isEosl,
                      tag: tag,
                    );
                    context.read<EoslBloc>().add(UpdateEosl(updatedEosl));
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// 삭제 모달을 표시하는 함수
  void _showDeleteModal(BuildContext context, PlutoRow row) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.teal[50], // 배경색 설정
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '정말로 삭제 하시겠습니까?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This action cannot be undone. Do you really want to delete this item?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel 버튼 디자인
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.teal, width: 2), // 테두리 설정
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 둥근 테두리
                          ),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Delete 버튼 디자인
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<EoslBloc>()
                              .add(DeleteEosl(row.cells['eosl_no']?.value));
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // 버튼 배경색
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 둥근 테두리
                          ),
                          elevation: 5, // 그림자 효과
                        ),
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
