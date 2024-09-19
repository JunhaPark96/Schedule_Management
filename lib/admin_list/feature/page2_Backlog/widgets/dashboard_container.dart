import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
// const primaryAppColor =Color()

class DashboardContainer extends StatelessWidget {
  final Colors color;
  final String title;
  final String mainData;
  final String topIcon;
  final Colors topIconColor;
  final bool willContainRow;

  const DashboardContainer({
    super.key,
    required this.color,
    required this.title,
    required this.mainData,
    required this.topIcon,
    required this.topIconColor,
    this.willContainRow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(),
        )
      ],
    );
  }
}
