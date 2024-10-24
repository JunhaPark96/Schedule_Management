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
          tag: '', // 기본값 추가
          maintenanceDate: DateTime.now().toIso8601String(),
          maintenanceTitle: '',
          maintenanceContent: '',
        ),
      );

      // 유지보수 데이터 로드
      taskController.text = maintenance.maintenanceTitle;
      specialNotesController.text = maintenance.maintenanceContent;
      dateController.text = maintenance.maintenanceDate.isNotEmpty
          ? DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(maintenance.maintenanceDate))
          : DateFormat('yyyy-MM-dd').format(DateTime.now());
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

    // 새로운 유지보수 데이터를 생성
    final newMaintenance = EoslMaintenance(
      maintenanceNo: widget.maintenanceNo,
      hostName: widget.hostName,
      tag: '', // 태그는 다른 곳에서 설정되거나 기본값으로
      maintenanceDate: dateController.text,
      maintenanceTitle: taskController.text,
      maintenanceContent: specialNotesController.text,
    );

    // 유지보수 데이터를 블록에 전송하여 저장
    eoslBloc.add(
      AddTaskToEoslDetail(
        newMaintenance.maintenanceNo,
        newMaintenance.hostName,
        newMaintenance.tag,
        newMaintenance.maintenanceDate,
        newMaintenance.maintenanceTitle,
        newMaintenance.maintenanceContent,
      ),
    );
    Navigator.of(context).pop(); // 저장 후 페이지를 닫
  }

  //  void _saveTask() {
  //   final eoslBloc = context.read<EoslBloc>();

  //   final newMaintenance = EoslMaintenance(
  //     maintenanceNo: widget.maintenanceNo,
  //     hostName: widget.hostName,
  //     tag: '', // 태그는 다른 곳에서 설정되거나 기본값으로
  //     maintenanceDate: dateController.text,
  //     maintenanceTitle: taskController.text,
  //     maintenanceContent: specialNotesController.text,
  //   );

  //   // 작업 저장
  //   if (widget.maintenanceNo == 'new_task') {
  //     eoslBloc.add(InsertEoslMaintenance(newMaintenance));
  //   } else {
  //     eoslBloc.add(UpdateEoslMaintenance(widget.maintenanceNo, newMaintenance));
  //   }

  //   Navigator.of(context).pop();
  // }

  void _deleteTask() {
    final eoslBloc = context.read<EoslBloc>();

    eoslBloc.add(DeleteEoslMaintenance(widget.maintenanceNo));

    Navigator.of(context).pop();
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        attachedFiles.addAll(result.files);
      });
    }
  }

  void removeFile(int index) {
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
                                decoration: boxDecoration(),
                                padding: const EdgeInsets.all(16),
                                constraints: const BoxConstraints(
                                  minHeight: maxHeight,
                                  maxHeight: maxHeight,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildEoslDetailTile(context, eoslDetail),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  buildTaskInformationSection(),
                  const SizedBox(height: 16),
                  buildAttachmentSection(),
                  const SizedBox(height: 16),
                  buildSubmitButton(context),
                ],
              ),
            ),
    );
  }

  BoxDecoration boxDecoration() {
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

  Widget buildEoslDetailTile(BuildContext context, EoslDetailModel detail) {
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

  Widget buildTaskInformationSection() {
    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration(),
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
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: () {
                    setState(() {
                      // 아이콘을 클릭할 때 수정 모드 상태를 토글
                      isEditing = !isEditing;
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

  Widget buildAttachmentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '첨부파일',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: pickFiles,
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
                onPressed: () => removeFile(attachedFiles.indexOf(file)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    final isNewTask = widget.maintenanceNo == 'new_task';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _saveTask(); // **`isEditing`과 무관하게 저장 기능 동작**
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // 새 작업인 경우 '작업 등록', 기존 작업이면 '작업 수정' 버튼 표시
          child: Text(isNewTask ? '작업 등록' : '작업 수정'),
        ),
        const SizedBox(width: 16),
        // **작업 삭제 버튼** - `isEditing`과 상관없이 삭제 가능
        if (!isNewTask)
          ElevatedButton(
            onPressed: _deleteTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('작업 삭제'),
          ),
      ],
    );
  }
}
