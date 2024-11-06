import 'package:flutter/material.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/lib/src/manager/pluto_grid_state_manager.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/model/pluto_column.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/model/pluto_row.dart';
import '../lib/src/ui/miscellaneous/pluto_state_with_change.dart';

class PlutoGrid extends PlutoStatefulWidget {
  const PlutoGrid({
    super.key,
    required this.columns,
    required this.rows,
  });
  final List<PlutoColumn> columns;
  final List<PlutoRow> rows;

  @override
  PlutoGridState createState() => PlutoGridState();
}

class PlutoGridState extends PlutoStateWithChange<PlutoGrid> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('data'),
    );
  }

  @override
  // TODO: implement stateManager
  PlutoGridStateManager get stateManager => throw UnimplementedError();
}

abstract class PlutoGridSettings {
  /// If there is a frozen column, the minimum width of the body
  /// (if it is less than the value, the frozen column is released)
  static const double bodyMinWidth = 200.0;

  /// Default column width
  static const double columnWidth = 200.0;

  /// Column width
  static const double minColumnWidth = 80.0;

  /// Frozen column division line (ShadowLine) size
  static const double shadowLineSize = 3.0;

  /// Sum of frozen column division line width
  static const double totalShadowLineWidth =
      PlutoGridSettings.shadowLineSize * 2;

  /// Grid - padding
  static const double gridPadding = 2.0;

  /// Grid - border width
  static const double gridBorderWidth = 1.0;

  static const double gridInnerSpacing =
      (gridPadding * 2) + (gridBorderWidth * 2);

  /// Row - Default row height
  static const double rowHeight = 45.0;

  /// Row - border width
  static const double rowBorderWidth = 1.0;

  /// Row - total height
  static const double rowTotalHeight = rowHeight + rowBorderWidth;

  /// Cell - padding
  static const EdgeInsets cellPadding = EdgeInsets.symmetric(horizontal: 10);

  /// Column title - padding
  static const EdgeInsets columnTitlePadding =
      EdgeInsets.symmetric(horizontal: 10);

  static const EdgeInsets columnFilterPadding = EdgeInsets.all(5);

  /// Cell - fontSize
  static const double cellFontSize = 14;

  /// Scroll when multi-selection is as close as that value from the edge
  static const double offsetScrollingFromEdge = 10.0;

  /// Size that scrolls from the edge at once when selecting multiple
  static const double offsetScrollingFromEdgeAtOnce = 200.0;

  static const int debounceMillisecondsForColumnFilter = 300;
}
