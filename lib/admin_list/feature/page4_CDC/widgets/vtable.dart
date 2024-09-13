import 'package:flutter/material.dart';
import 'copy_action.dart';
import 'theme.dart';

typedef ItemTapHandler<T> = void Function(T object);
typedef OnSelectionChanged<T> = void Function(T? selectedItem);

class VTable<T> extends StatefulWidget {
  static const double _vertPadding = 4;
  static const double _horizPadding = 8;

  final List<T> items;
  final List<VTableColumn<T>> columns;
  final bool startsSorted;
  final bool supportsSelection;
  final ItemTapHandler<T>? onDoubleTap;
  final OnSelectionChanged<T>? onSelectionChanged;
  final String? tableDescription;
  final List<Widget> filterWidgets;
  final List<Widget> actions;
  final Duration tooltipDelay;
  final double rowHeight;
  final bool includeCopyToClipboardAction;
  final bool showHeaders;
  final bool showToolbar;

  const VTable({
    required this.items,
    required this.columns,
    this.startsSorted = false,
    this.supportsSelection = false,
    this.onDoubleTap,
    this.onSelectionChanged,
    this.tableDescription,
    this.filterWidgets = const [],
    this.actions = const [],
    this.tooltipDelay = defaultTooltipDelay,
    this.rowHeight = defaultRowHeight,
    this.includeCopyToClipboardAction = false,
    this.showHeaders = true,
    this.showToolbar = true,
    Key? key,
  }) : super(key: key);

  @override
  State<VTable> createState() => _VTableState<T>();
}

class _VTableState<T> extends State<VTable<T>> {
  late ScrollController scrollController;
  late List<T> sortedItems;
  int? sortColumnIndex;
  bool sortAscending = true;
  final ValueNotifier<T?> selectedItem = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    sortedItems = widget.items.toList();
    _performInitialSort();

    selectedItem.addListener(() {
      if (widget.onSelectionChanged != null) {
        widget.onSelectionChanged!(selectedItem.value);
      }
    });
  }

  @override
  void didUpdateWidget(VTable<T> oldWidget) {
    sortedItems = widget.items;
    _performInitialSort();

    //Clear the selection if the selected item id no longer in the table
    if (selectedItem.value != null &&
        !sortedItems.contains(selectedItem.value)) {
      selectedItem.value = null;
    }
  }

  void _performInitialSort() {
    if (widget.startsSorted && columns.first.supportsSort) {
      columns.first.sort(sortedItems, ascending: true);
      sortColumnIndex = 0;
    }
  }

  List<VTableColumn<T>> get columns => widget.columns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showToolbar) createActionRow(context),
        if (widget.showToolbar) const Divider(),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              Map<VTableColumn, double> colWidths = _layoutColumns(constraints);

              return Column(
                children: [
                  if (widget.showHeaders) createHeaderRow(colWidths),
                  Expanded(
                    child: createRowsListView(context, colWidths),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Padding createActionRow(BuildContext context) {
    final extraActions = [];

    if (widget.includeCopyToClipboardAction) {
      if (widget.actions.isNotEmpty) {
        extraActions.add(
            const SizedBox(height: toolbarHeight, child: VerticalDivider()));
      }
      extraActions.add(CopyToClipboardAction<T>());
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 16),
      child: Row(
        children: [
          Text(widget.tableDescription ?? ''),
          const Expanded(
              child: SizedBox(
            width: 8,
          )),
          ...widget.filterWidgets,
          const Expanded(
              child: SizedBox(
            width: 8,
          )),
          ...widget.actions,
          ...extraActions,
        ],
      ),
    );
  }

  Row createHeaderRow(Map<VTableColumn<dynamic>, double> colWidths) {
    var sortColumn = sortColumnIndex == null ? null : columns[sortColumnIndex!];

    return Row(
      children: [
        for (var column in columns)
          InkWell(
            onTap: () => trySort(column),
            child: _ColumnHeader(
              title: column.label,
              icon: column.icon,
              width: colWidths[column],
              height: widget.rowHeight,
              alignment: column.alignment,
              sortAscending: column == sortColumn ? sortAscending : false,
            ),
          ),
      ],
    );
  }

  ListView createRowsListView(
    BuildContext context,
    Map<VTableColumn<dynamic>, double> colWidths,
  ) {
    final theme = Theme.of(context);
    final rowSeparator = BoxDecoration(
      border: Border(top: BorderSide(color: theme.dividerColor)),
    );

    final colorScheme = theme.colorScheme;
    final darkMode = colorScheme.brightness == Brightness.dark;

    return ListView.builder(
      controller: scrollController,
      itemCount: sortedItems.length,
      itemExtent: widget.rowHeight,
      itemBuilder: (BuildContext context, int index) {
        T item = sortedItems[index];
        final selected = item == selectedItem.value;
        return Container(
          key: ValueKey(item),
          color: selected ? Theme.of(context).hoverColor : null,
          child: InkWell(
            onTap: () => _select(item),
            onDoubleTap: () => _doubleTap(item),
            child: DecoratedBox(
              decoration: (widget.showHeaders || index != 0)
                  ? rowSeparator
                  : const BoxDecoration(),
              child: Row(
                children: [
                  for (var column in columns)
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 1),
                      child: SizedBox(
                          height: widget.rowHeight - 1,
                          width: colWidths[column]! - 1,
                          child: Tooltip(
                              message: column.validate(item)?.message ?? '',
                              waitDuration: widget.tooltipDelay,
                              child: Container(
                                // alignment:column.alignment ?? Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: VTable._horizPadding,
                                  vertical: VTable._vertPadding,
                                ),
                                color: column
                                    .validate(item)
                                    ?.colorForSeverity(darkMode: darkMode),
                                child: column.widgetFor(context, item),
                              ))),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void trySort(VTableColumn<T> column) {
    if (!column.supportsSort) {
      return;
    }

    setState(() {
      int newIndex = columns.indexOf(column);
      if (sortColumnIndex == newIndex) {
        sortAscending = !sortAscending;
      } else {
        sortAscending = true;
      }

      sortColumnIndex = newIndex;
      column.sort(sortedItems, ascending: sortAscending);
    });
  }

  Map<VTableColumn, double> _layoutColumns(BoxConstraints constraints) {
    double width = constraints.maxWidth;

    Map<VTableColumn, double> widths = {};
    double minColWtidth = 0;
    double totalGrow = 0;
    for (var col in columns) {
      minColWtidth += col.width;
      totalGrow += col.grow;
      widths[col] = col.width.toDouble();
    }
    width -= minColWtidth;

    if (width > 0 && totalGrow > 0) {
      for (var col in columns) {
        if (col.grow > 0) {
          var inc = width * (col.grow / totalGrow);
          widths[col] = widths[col]! + inc;
        }
      }
    }
    return widths;
  }

  void _select(T item) {
    if (widget.supportsSelection) {
      setState(
        () {
          if (selectedItem.value != item) {
            selectedItem.value = item;
          } else {
            selectedItem.value = null;
          }
        },
      );
    }
  }

  void _doubleTap(T item) {
    if (widget.onDoubleTap != null) {
      widget.onDoubleTap!(item);
    }
  }
}

class _ColumnHeader extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final IconData? icon;
  final Alignment? alignment;
  final bool? sortAscending;

  const _ColumnHeader({
    required this.title,
    required this.width,
    required this.height,
    this.icon,
    this.alignment,
    this.sortAscending,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var swapSortIconSized = alignment != null && alignment!.x > 0;
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: VTable._horizPadding,
          vertical: VTable._vertPadding,
        ),
        child: Row(children: [
          if (sortAscending != null && swapSortIconSized)
            AnimatedRotation(
              turns: sortAscending! ? 0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_up,
              ),
            ),
          Expanded(
            child: icon != null
                ? Tooltip(
                    message: title,
                    child: Align(
                      alignment: alignment ?? Alignment.centerLeft,
                      child: Icon(icon),
                    ),
                  )
                : Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: swapSortIconSized ? TextAlign.end : null,
                  ),
          ),
          if (sortAscending != null && !swapSortIconSized)
            AnimatedRotation(
              turns: sortAscending! ? 0 : 0.5,
              duration: Duration(milliseconds: 200),
              child: Icon(icon),
            ),
        ]),
      ),
    );
  }
}

typedef RenderFunction<T> = Widget? Function(
    BuildContext context, T object, String out);

typedef TransformFunction<T> = String Function(T object);

typedef StyleFunction<T> = TextStyle? Function(T object);

typedef CompareFunction<T> = int Function(T a, T b);

typedef ValidationFunction<T> = ValidationResult? Function(T object);

class VTableColumn<T> {
  final String label;
  final IconData? icon;
  final int width;
  final double grow;
  final Alignment? alignment;
  final TransformFunction<T>? transformFunction;
  final StyleFunction<T>? styleFunction;
  final CompareFunction<T>? compareFunction;
  final List<ValidationFunction<T>> validators;
  final RenderFunction<T>? renderFuntion;

  VTableColumn({
    required this.label,
    required this.width,
    this.icon,
    this.alignment,
    this.grow = 0,
    this.transformFunction,
    this.styleFunction,
    this.compareFunction,
    this.validators = const [],
    this.renderFuntion,
  });

  Widget widgetFor(BuildContext context, T item) {
    final out = transformFunction != null ? transformFunction!(item) : '$item';

    if (renderFuntion != null) {
      Widget? widget = renderFuntion!(context, item, out);
      if (widget != null) return widget;
    }
    var style = styleFunction == null ? null : styleFunction!(item);
    return Text(
      out,
      style: style,
      maxLines: 2,
    );
  }

  void sort(List<T> items, {required bool ascending}) {
    if (compareFunction != null) {
      items
          .sort(ascending ? compareFunction : (a, b) => compareFunction!(b, a));
    } else if (transformFunction != null) {
      items.sort((T a, T b) {
        var strA = transformFunction!(a);
        var strB = transformFunction!(b);
        return ascending ? strA.compareTo(strB) : strB.compareTo(strA);
      });
    }
  }

  bool get supportsSort => compareFunction != null || transformFunction != null;

  ValidationResult? validate(T item) {
    if (validators.isEmpty) {
      return null;
    } else if (validators.length == 1) {
      return validators.first(item);
    } else {
      List<ValidationResult> results = [];
      for (var validator in validators) {
        ValidationResult? result = validator(item);
        if (result != null) {
          results.add(result);
        }
      }
      return ValidationResult.combine(results);
    }
  }
}

enum Severity { info, note, warning, error }

class ValidationResult {
  final String message;
  final Severity severity;

  ValidationResult(this.message, this.severity);

  factory ValidationResult.error(String message) =>
      ValidationResult(message, Severity.error);
  factory ValidationResult.warning(String message) =>
      ValidationResult(message, Severity.warning);
  factory ValidationResult.note(String message) =>
      ValidationResult(message, Severity.note);
  factory ValidationResult.info(String message) =>
      ValidationResult(message, Severity.info);

  Color colorForSeverity({bool darkMode = true}) {
    if (darkMode) {
      switch (severity) {
        case Severity.info:
          return Colors.grey.shade400;
        case Severity.note:
          return Colors.blue.shade200;
        case Severity.warning:
          return Colors.yellow.shade200;
        case Severity.error:
          return Colors.red.shade300;
      }
    } else {
      switch (severity) {
        case Severity.info:
          return Colors.grey.shade400.withAlpha(127);
        case Severity.note:
          return Colors.blue.shade200.withAlpha(127);
        case Severity.warning:
          return Colors.yellow.shade200.withAlpha(127);
        case Severity.error:
          return Colors.red.shade300.withAlpha(127);
      }
    }
  }

  @override
  String toString() => '$severity $message';
  static ValidationResult? combine(List<ValidationResult> results) {
    if (results.isEmpty) {
      return null;
    } else if (results.length == 1) {
      return results.first;
    } else {
      String message = results.map((r) => r.message).join('\n');
      Severity severity = results
          .map((r) => r.severity)
          .reduce((a, b) => a.index >= b.index ? a : b);
      return ValidationResult(message, severity);
    }
  }
}
