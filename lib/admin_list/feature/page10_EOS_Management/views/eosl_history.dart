import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart'; // 파일 선택을 위한 패키지
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_state.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/widgets/html_editor.dart';
import 'package:intl/intl.dart';

class EoslHistoryPage extends StatefulWidget {
  final String hostName;
  final String maintenanceNo;

  const EoslHistoryPage({
    super.key,
    required this.hostName,
    required this.maintenanceNo,
  });

  @override
  _EoslHistoryPageState createState() => _EoslHistoryPageState();
}

class _EoslHistoryPageState extends State<EoslHistoryPage> {
  bool isEditing = false; // 수정 모드 상태 변수
  TextEditingController taskController =
      TextEditingController(); // 작업 내용 입력 컨트롤러
  TextEditingController specialNotesController =
      TextEditingController(); // 특이사항 입력 컨트롤러
  TextEditingController dateController = TextEditingController(); // 날짜 입력 컨트롤러
  List<PlatformFile> attachedFiles = []; // 첨부된 파일 목록

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 데이터 로드
  Future<void> _loadData() async {
    final eoslBloc = context.read<EoslBloc>();
    eoslBloc.add(FetchEoslDetail(widget.hostName));

    final eoslState = eoslBloc.state;
    if (eoslState.eoslMaintenanceList.isNotEmpty) {
      final maintenance = eoslState.eoslMaintenanceList.firstWhere(
        (m) => m.maintenanceNo == widget.maintenanceNo,
        orElse: () => EoslMaintenance(
          maintenanceNo: widget.maintenanceNo,
          hostName: widget.hostName,
          maintenanceDate: DateTime.now().toIso8601String(),
          tasks: [],
        ),
      );
      if (maintenance.tasks.isNotEmpty) {
        final task = maintenance.tasks.first; // 첫 번째 작업을 로드
        taskController.text = task['title'] ?? '';
        specialNotesController.text = task['content'] ?? '';
        dateController.text = maintenance.maintenanceDate != null
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(maintenance.maintenanceDate))
            : DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
    } else {
      taskController.text = '';
      specialNotesController.text = '';
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print(
          'EoslHistoryPage: 데이터 조회 실패 - 호스트 이름: ${widget.hostName}, 유지보수 번호: ${widget.maintenanceNo}');
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _saveTask() {
    final eoslBloc = context.read<EoslBloc>();
    final newTask = {
      'date': dateController.text,
      'title': taskController.text,
      'content': specialNotesController.text,
    };

    eoslBloc.add(
        AddTaskToEoslDetail(widget.hostName, newTask, dateController.text));
    Navigator.of(context).pop(); // 저장 후 페이지를 닫음
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        attachedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      attachedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eoslDetail = context.select<EoslBloc, EoslDetailModel?>(
      (bloc) => bloc.state.eoslDetailList.firstWhere(
        (detail) => detail.hostName == widget.hostName,
        orElse: () => EoslDetailModel(
          hostName: widget.hostName,
          field: '정보 없음',
          quantity: '정보 없음',
          note: '정보 없음',
          supplier: '정보 없음',
          eoslDate: '정보 없음',
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('유지보수 작업 상세: ${widget.hostName}'),
        backgroundColor: Colors.teal,
      ),
      body: eoslDetail == null
          ? const Center(child: Text('데이터를 불러오는 중 오류가 발생'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const double maxHeight = 200;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: _boxDecoration(),
                                padding: const EdgeInsets.all(16),
                                constraints: const BoxConstraints(
                                  minHeight: maxHeight,
                                  maxHeight: maxHeight,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildEoslDetailTile(context, eoslDetail),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  _buildTaskInformationSection(),
                  const SizedBox(height: 16),
                  _buildAttachmentSection(),
                  const SizedBox(height: 16),
                  _buildSubmitButton(context),
                ],
              ),
            ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildEoslDetailTile(BuildContext context, EoslDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          title: Text(
            'Host Name: ${detail.hostName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Field: ${detail.field}'),
              Text('Quantity: ${detail.quantity}'),
              Text('Note: ${detail.note}'),
              Text('Supplier: ${detail.supplier}'),
              Text('EOSL Date: ${detail.eoslDate}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskInformationSection() {
    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '작업 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (!isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (isEditing)
              InkWell(
                onTap: () => _pickDate(context),
                child: IgnorePointer(
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: '날짜를 선택하세요',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              )
            else
              Text(
                dateController.text.isNotEmpty
                    ? '날짜: ${dateController.text}' // 기존 날짜 표시
                    : '날짜: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', // 새로운 태스크일 경우 오늘 날짜 표시
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 8),
            if (isEditing)
              TextField(
                controller: taskController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '제목을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text(
                taskController.text.isNotEmpty
                    ? '제목: ${taskController.text}'
                    : '제목 작성',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 8),
            if (isEditing)
              SizedBox(
                height: 300, // isEditing일 때 높이 증가
                child: TextField(
                  controller: specialNotesController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: '특이사항 및 권고사항 입력',
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            else
              Text(
                specialNotesController.text.isNotEmpty
                    ? '특이사항: ${specialNotesController.text}'
                    : '특이사항 및 권고사항',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '첨부파일',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _pickFiles,
            icon: const Icon(Icons.attach_file),
            label: const Text('파일 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...attachedFiles.map(
            (file) => ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text('파일명: ${file.name}'),
              subtitle: Text('용량: ${(file.size / 1024).toStringAsFixed(2)} KB'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeFile(attachedFiles.indexOf(file)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (isEditing) {
            _saveTask(); // Task 등록
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('작업 등록'),
      ),
    );
  }
}
