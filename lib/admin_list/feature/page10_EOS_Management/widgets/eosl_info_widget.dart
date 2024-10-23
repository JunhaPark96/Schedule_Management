import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_detail_model.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/views/add_event_page.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/repos/contact_repository.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/views/contact_list_screen.dart'; // go_router 패키지를 사용해 페이지 간 이동 처리

class EoslInfoWidget extends StatelessWidget {
  final EoslDetailModel eoslDetailModel;

  const EoslInfoWidget({
    super.key,
    required this.eoslDetailModel,
  });

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
          _buildInfoRow('호스트 네임:', eoslDetailModel.hostName ?? '없음'),
          _buildInfoRow('구분:', eoslDetailModel.field ?? '없음'),
          _buildInfoRow('상세:', eoslDetailModel.note ?? '없음'),
          _buildInfoRow('유지보수 횟수:', eoslDetailModel.quantity ?? '없음'),
          _buildSupplierRow(context, '납품업체:', eoslDetailModel.supplier ?? '없음'),
          _buildEoslDateRow(context, eoslDetailModel.eoslDate ?? '없음'),
        ],
      ),
    );
  }

  // 납품업체를 클릭 시 eoslMaintenance 페이지로 이동하는 Row
  Widget _buildSupplierRow(
      BuildContext context, String label, String supplier) {
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
            child: GestureDetector(
              // onTap: () {
              //   context.go('/eoslMaintenance'); // eoslMaintenance 페이지로 이동
              // },

              onTap: () {
                // EOS 날짜 등록 로직 ==> add_event_page로 이동
                Navigator.push(
                  context,
                  // MaterialPageRoute(
                  //   builder: (context) => ContactListScreen(
                  //     contactRepository: ContactRepository(),
                  //   ),
                  //   settings: RouteSettings(
                  //     arguments: supplier, // supplier 이름을 arguments로 전달
                  //   ),
                  // ),
                  MaterialPageRoute(
                    builder: (context) => ContactListScreen(
                        // ContactListScreen에 supplier를 검색어로 전달
                        contactRepository: ContactRepository(),
                        initialSearchQuery: supplier,
                      ),
                  ),
                );
              },
              child: Text(
                supplier,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
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
                // MaterialPageRoute(
                //   builder: (context) => const AddEventPage(),
                //   settings: RouteSettings(arguments: eoslDetailModel),
                // ),
                MaterialPageRoute(
                  builder: (context) => AddEventPage(
                    eoslDetailModel: eoslDetailModel, // EoslDetailModel을 전달
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
