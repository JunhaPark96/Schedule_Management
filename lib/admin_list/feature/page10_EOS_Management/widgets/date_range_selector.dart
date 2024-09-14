import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final ValueChanged<DateTimeRange> onSearch;

  const DateRangeSelector({
    super.key,
    this.initialDateRange,
    required this.onSearch,
  });

  @override
  _DateRangeSelectorState createState() => _DateRangeSelectorState();
}

// DateRangeSelector 수정
class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    selectedDateRange = widget.initialDateRange;
  }

  void _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
      widget.onSearch(picked); // 선택된 날짜 범위로 필터링 수행
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: selectedDateRange != null
                    ? '${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}'
                    : '날짜 범위 선택',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
