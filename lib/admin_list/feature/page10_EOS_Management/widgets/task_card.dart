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
    final maintenanceNo = (maintenance.maintenanceNo?.isNotEmpty ?? false)
        ? maintenance.maintenanceNo!
        : 'No Maintenance No';
    final maintenanceDate = (maintenance.maintenanceDate?.isNotEmpty ?? false)
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(maintenance.maintenanceDate!))
        : 'No Date';
    final maintenanceTitle = (maintenance.maintenanceTitle?.isNotEmpty ?? false)
        ? maintenance.maintenanceTitle!
        : 'No Title';
    final maintenanceContent =
        (maintenance.maintenanceContent?.isNotEmpty ?? false)
            ? maintenance.maintenanceContent!
            : 'No Content Available';

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
                  Text(
                    maintenanceTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        maintenanceContent,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: $maintenanceDate',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
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
