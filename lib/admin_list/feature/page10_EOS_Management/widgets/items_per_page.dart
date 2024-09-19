import 'package:flutter/material.dart';

class ItemsPerPageSelector extends StatelessWidget {
  final int currentValue;
  final ValueChanged<int> onChanged;

  const ItemsPerPageSelector({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: currentValue,
      items: [5, 10, 25, 50].map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('$value 개씩 보기'),
        );
      }).toList(),
      onChanged: (int? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}
