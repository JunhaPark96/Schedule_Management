import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_maintenance_model.dart';

class TaskCard extends StatelessWidget {
  final EoslMaintenance maintenance;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.maintenance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // EoslMaintenance 데이터에서 필요한 필드 추출
    final maintenanceNo = maintenance.maintenanceNo ?? 'No Maintenance No';
    final tasks = maintenance.tasks; // List<Map<String, dynamic>> 형태
    final taskDetails = tasks.isNotEmpty
        ? tasks.map((task) {
            final taskContent = task['content'] ?? 'No content';
            final taskDate = task['date'] != null
                ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task['date']))
                : 'No date';
            return '• $taskContent ($taskDate)';
          }).join('\n')
        : 'No tasks available';

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        const cardHeight = 300.0;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maintenance No: $maintenanceNo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        taskDetails,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
