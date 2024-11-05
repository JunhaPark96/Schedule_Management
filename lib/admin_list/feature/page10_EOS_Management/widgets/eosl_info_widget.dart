import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/views/add_event_page.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/repos/contact_repository.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/views/contact_list_screen.dart'; // go_router 패키지를 사용해 페이지 간 이동 처리

class EoslInfoWidget extends StatefulWidget {
  final EoslDetailModel eoslDetailModel;

  const EoslInfoWidget({
    super.key,
    required this.eoslDetailModel,
  });

  @override
  _EoslInfoWidgetState createState() => _EoslInfoWidgetState();
}

class _EoslInfoWidgetState extends State<EoslInfoWidget> {
  late TextEditingController noteController;
  late TextEditingController quantityController;
  late TextEditingController supplierController;
  bool isEditingNote = false;
  bool isEditingQuantity = false;
  bool isEditingSupplier = false;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(text: widget.eoslDetailModel.note);
    quantityController =
        TextEditingController(text: widget.eoslDetailModel.quantity);
    supplierController =
        TextEditingController(text: widget.eoslDetailModel.supplier);
  }

  @override
  void dispose() {
    noteController.dispose();
    quantityController.dispose();
    supplierController.dispose();
    super.dispose();
  }

  void _toggleEdit(String field) {
    setState(() {
      if (field == 'note') {
        isEditingNote = !isEditingNote;
      } else if (field == 'quantity') {
        isEditingQuantity = !isEditingQuantity;
      } else if (field == 'supplier') {
        isEditingSupplier = !isEditingSupplier;
      }
    });
  }

  void _sendUpdateRequest() {
    final updatedDetail = EoslDetailModel(
      hostName: widget.eoslDetailModel.hostName,
      tag: widget.eoslDetailModel.tag,
      note: noteController.text,
      quantity: quantityController.text,
      supplier: supplierController.text,
      eoslDate: widget.eoslDetailModel.eoslDate,
    );

    context.read<EoslBloc>().add(UpdateEoslDetail(updatedDetail));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Update request sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.teal.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('호스트 네임:', widget.eoslDetailModel.hostName ?? '없음'),
          _buildInfoRow('구분:', widget.eoslDetailModel.tag ?? '없음'),
          _buildEditableRow('상세:', noteController, isEditingNote, 'note'),
          _buildEditableRow(
              '유지보수 횟수:', quantityController, isEditingQuantity, 'quantity'),
          _buildEditableRow(
              '납품업체:', supplierController, isEditingSupplier, 'supplier'),
          _buildEoslDateRow(context, widget.eoslDetailModel.eoslDate ?? '없음'),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _sendUpdateRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('내용 수정'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(String label, TextEditingController controller,
      bool isEditing, String field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(197, 0, 121, 107),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  )
                : GestureDetector(
                    onTap: field == 'supplier'
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactListScreen(
                                  contactRepository: ContactRepository(),
                                  initialSearchQuery: controller.text,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      controller.text.isNotEmpty ? controller.text : '없음',
                      style: TextStyle(
                        fontSize: 16,
                        color: field == 'supplier' ? Colors.blue : Colors.black,
                        decoration: field == 'supplier'
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () => _toggleEdit(field),
          ),
        ],
      ),
    );
  }

  // EOS 날짜 등록 버튼이 포함된 Row
  Widget _buildEoslDateRow(BuildContext context, String eoslDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'EOS 날짜:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(197, 0, 121, 107),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              eoslDate.isNotEmpty ? eoslDate : '없음',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // EOS 날짜 등록 로직 ==> add_event_page로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventPage(
                    eoslDetailModel: widget.eoslDetailModel,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('EOS 날짜 등록'),
          ),
        ],
      ),
    );
  }

  // 일반 정보 표시 Row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(197, 0, 121, 107),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
