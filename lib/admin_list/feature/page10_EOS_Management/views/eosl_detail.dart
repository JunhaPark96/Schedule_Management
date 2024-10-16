import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_state.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/views/eosl_history.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/eosl_info_widget.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/date_range_selector.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/items_per_page.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/search_bar.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/task_card.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';

class EoslDetailPage extends StatefulWidget {
  final String hostName;

  const EoslDetailPage({
    super.key,
    required this.hostName,
  });

  @override
  _EoslDetailPageState createState() => _EoslDetailPageState();
}

class _EoslDetailPageState extends State<EoslDetailPage> {
  int itemsPerPage = 10; // 한 페이지에 보여줄 아이템 수
  int currentPage = 1; // 현재 페이지 번호
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 1000)),
    end: DateTime.now().add(const Duration(days: 7)),
  ); // 기본 기간 설정 (현재 날짜부터 한달 전까지)
  String searchQuery = ""; // 검색할 텍스트
  List<EoslMaintenance> maintenances = []; // 전체 Maintenance 리스트
  List<EoslMaintenance> visibleMaintenances = []; // 필터링된 Maintenance 리스트

  @override
  void initState() {
    super.initState();
    _loadData(); // 초기 데이터 로드
  }

  // 데이터를 로드하는 메서드
  void _loadData() {
    final eoslBloc = context.read<EoslBloc>();
    eoslBloc.add(FetchEoslDetail(widget.hostName)); // 특정 호스트의 상세 데이터를 로드
  }

  // 필터를 적용하는 메서드
  // void _applyFilters() {
  //   final filteredMaintenances = maintenances.where((maintenance) {
  //     final maintenanceDate = maintenance.maintenanceDate != null
  //         ? DateTime.tryParse(maintenance.maintenanceDate)
  //         : null;

  //     // 유지보수 날짜 필터링
  //     final isWithinDateRange = maintenanceDate == null ||
  //         (maintenanceDate.isAfter(selectedDateRange.start) &&
  //             maintenanceDate.isBefore(selectedDateRange.end));

  //     // 각 태스크의 title과 content에 대한 검색 필터링
  //     final taskMatchesSearchQuery = maintenance.tasks.any((task) {
  //       final taskTitle = task['title']?.toLowerCase() ?? '';
  //       final taskContent = task['content']?.toLowerCase() ?? '';

  //       return taskTitle.contains(searchQuery) ||
  //           taskContent.contains(searchQuery);
  //     });

  //     return isWithinDateRange && taskMatchesSearchQuery;
  //   }).toList();
    // 필터를 적용하는 메서드
  void _applyFilters() {
    final filteredMaintenances = maintenances.where((maintenance) {
      final maintenanceDate = maintenance.maintenanceDate != null
          ? DateTime.tryParse(maintenance.maintenanceDate)
          : null;

      // 유지보수 날짜 필터링
      final isWithinDateRange = maintenanceDate == null ||
          (maintenanceDate.isAfter(selectedDateRange.start) &&
              maintenanceDate.isBefore(selectedDateRange.end));

      // 유지보수 제목과 내용에 대한 검색 필터링
      final titleMatchesSearchQuery = maintenance.maintenanceTitle
          .toLowerCase()
          .contains(searchQuery);
      final contentMatchesSearchQuery = maintenance.maintenanceContent
          .toLowerCase()
          .contains(searchQuery);

      // 검색어가 제목이나 내용에 일치하고, 날짜 범위 내에 있는지 확인
      return isWithinDateRange &&
          (titleMatchesSearchQuery || contentMatchesSearchQuery);
    }).toList();

    // 빌드 단계 이후에 상태 업데이트
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        visibleMaintenances = filteredMaintenances
            .skip((currentPage - 1) * itemsPerPage)
            .take(itemsPerPage)
            .toList();
      });
    });
  }

  // 날짜 범위를 필터링하는 메서드
  void _filterTasks(DateTimeRange range) {
    setState(() {
      selectedDateRange = range;
      currentPage = 1; // 필터 적용 시 첫 페이지로 리셋
    });
    _applyFilters(); // 필터링 적용
  }

  // 검색어에 따라 필터링하는 메서드
  void _searchTasks(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // 검색어를 소문자로 변환
      currentPage = 1; // 첫 페이지로 리셋
    });
    _applyFilters(); // 검색어에 따른 필터링 적용
  }

  // 새로운 Task를 추가하는 메서드
  void _addTask() {
    // 새로운 작업을 추가할 때 "new_task"라는 특수 인자를 사용하여 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EoslHistoryPage(
          hostName: widget.hostName,
          maintenanceNo: 'new_task',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hostNameKey = widget.hostName.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EOSL 상세 정보'),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<EoslBloc, EoslState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error.isNotEmpty) {
            return Center(child: Text('데이터 로드 중 오류 발생: ${state.error}'));
          } else if (state.eoslDetailList.isNotEmpty) {
            final eoslDetailModel = state.eoslDetailList.firstWhere(
              (eosl) => eosl.hostName == hostNameKey,
              orElse: () => EoslDetailModel(
                  hostName: hostNameKey,
                  field: '정보 없음',
                  quantity: '정보 없음',
                  note: '정보 없음',
                  supplier: '정보 없음',
                  eoslDate: '정보 없음'),
            );

            maintenances = state.eoslMaintenanceList; // Maintenance 리스트 로드
            _applyFilters(); // 필터 적용

            return _buildDetailContent(context, eoslDetailModel);
          } else {
            return const Center(child: Text('해당 호스트 정보를 찾을 수 없습니다.'));
          }
        },
      ),
    );
  }

  // 상세 정보를 표시하는 메서드
  Widget _buildDetailContent(
      BuildContext context, EoslDetailModel eoslDetailModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EoslInfoWidget(eoslDetailModel: eoslDetailModel),
        const SizedBox(height: 16),
        Center(
          child: CustomSearchBar(
            onSearch: _searchTasks,
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ItemsPerPageSelector(
                    currentValue: itemsPerPage,
                    onChanged: (value) {
                      setState(() {
                        itemsPerPage = value;
                        currentPage = 1;
                      });
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DateRangeSelector(
                    initialDateRange: selectedDateRange,
                    onSearch: _filterTasks,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '유지보수 이력',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    (MediaQuery.of(context).size.width / 3 - 20) / 300,
              ),
              itemCount:
                  visibleMaintenances.length + 1, // 유지보수 이력 개수 + 1 (플러스 버튼)
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: _addTask,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: Colors.teal.shade50,
                      child: const Center(
                        child: Icon(Icons.add, size: 50, color: Colors.teal),
                      ),
                    ),
                  );
                }

                final maintenance = visibleMaintenances[index - 1];
                return TaskCard(
                  maintenance: maintenance,
                  onTap: () {
                    // 기존의 taskIndex 대신 maintenanceNo를 전달하여 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EoslHistoryPage(
                          hostName: widget.hostName,
                          maintenanceNo:
                              maintenance.maintenanceNo, // maintenanceNo 사용
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),

        // 페이지 네비게이션 버튼 추가
        if ((visibleMaintenances.length / itemsPerPage).ceil() > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                          _applyFilters();
                        }
                      : null,
                ),
                Text(
                    'Page $currentPage of ${(visibleMaintenances.length / itemsPerPage).ceil()}'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: currentPage <
                          (visibleMaintenances.length / itemsPerPage).ceil()
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                          _applyFilters();
                        }
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
