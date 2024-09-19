import 'dart:js_interop';
import 'dart:math';
import 'package:faker/faker.dart' as fakerimport;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:collection/collection.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/lib/src/model/pluto_column_type.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/model/license_model.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/view_models/license_bloc.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/view_models/license_event.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/view_models/license_state.dart';
import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import '../repos/license_repos.dart';
import '../lib/pluto_grid.dart';

class Plutotable extends StatefulWidget {
  const Plutotable({super.key});

  @override
  State<Plutotable> createState() => _PlutotableState();
}

class _PlutotableState extends State<Plutotable> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    columns.addAll([
      PlutoColumn(
        title: 'INDEX',
        field: 'INDEX',
        suppressedAutoSize: true,
        readOnly: true,
        type: PlutoColumnType.number(),
        sort: PlutoColumnSort.ascending,
        width: 60,
      ),
      PlutoColumn(
        title: 'ID',
        field: 'ID',
        readOnly: true,
        type: PlutoColumnType.number(),
        frozen: PlutoColumnFrozen.end,
        // hide: true,
        // sort: PlutoColumnSort.ascending,
        width: 60,
      ),
      PlutoColumn(
        title: '라이센스',
        field: '라이센스',
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: '업무구분',
        field: '업무구분',
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: 'HostName',
        field: 'HostName',
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: 'IP',
        field: 'IP',
        type: PlutoColumnType.text(),
        width: 120,
      ),
      PlutoColumn(
        title: '등급',
        field: '등급',
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: '보유',
        field: '보유',
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: 'PL',
        field: 'PL',
        type: PlutoColumnType.text(),
        width: 80,
      ),
      PlutoColumn(
        title: 'NUP RAC',
        field: 'NUP RAC',
        type: PlutoColumnType.number(),
        width: 100,
      ),
      PlutoColumn(
        title: 'NUP',
        field: 'NUP',
        type: PlutoColumnType.number(),
        width: 80,
      ),
      PlutoColumn(
        title: 'RAC',
        field: 'RAC',
        type: PlutoColumnType.number(),
        width: 80,
      ),
      PlutoColumn(
        title: 'Version',
        field: 'Version',
        type: PlutoColumnType.text(),
        width: 80,
      ),
      PlutoColumn(
        title: '만료일',
        field: '만료일',
        type: PlutoColumnType.date(),
        backgroundColor: Colors.amber.shade100,
        width: 100,
      ),
      PlutoColumn(
        title: 'Status',
        field: 'status',
        type: PlutoColumnType.select(<String>[
          'saved',
          'edited',
          'created',
        ]),
        enableEditingMode: false,
        frozen: PlutoColumnFrozen.end,
        titleSpan: const TextSpan(children: [
          WidgetSpan(
              child: Icon(
            Icons.lock,
            size: 17,
          )),
          TextSpan(text: 'Status'),
        ]),
        backgroundColor: Colors.amber,
        renderer: (rendererContext) {
          Color textColor = Colors.black;

          if (rendererContext.cell.value == 'saved') {
            textColor = Colors.green;
          } else if (rendererContext.cell.value == 'edited') {
            textColor = Colors.orange;
          } else if (rendererContext.cell.value == 'created') {
            textColor = Colors.blue;
          } else if (rendererContext.cell.value == 'delete') {
            textColor = Colors.red;
          }

          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    ]);
  }

  final List<PlutoColumn> columns = <PlutoColumn>[];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'ID', fields: ['ID'], expandedColumn: true),
    PlutoColumnGroup(title: '업무구분', fields: ['업무구분'], expandedColumn: true),
    PlutoColumnGroup(
        backgroundColor: Colors.brown.shade100,
        title: 'Oracle Database',
        fields: ['PL', 'NUP RAC', 'NUP', 'RAC']),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License List'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              logoutDialoge(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child:
            BlocBuilder<LicenseBloc, LicenseState>(builder: (context, state) {
          if (state.prow.isEmpty) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 25,
                color: CupertinoColors.activeBlue,
              ),
            );
          }

          // print('state.prow!: ${state.prow}');
          // print('state.list!: ${state.list}');

          return PlutoGrid(
            columns: columns,
            rows: state.prow,
            columnGroups: columnGroups,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
              stateManager.setShowColumnFilter(true);
            },
            createHeader: (stateManager) => _Header(stateManager: stateManager),
            onChanged: (PlutoGridOnChangedEvent event) {
              if (event.row.cells['status']!.value == 'saved' ||
                  event.row.cells['status']!.value == 'created') {
                event.row.cells['status']!.value = 'edited';
              }
              // print('event : ${event}');

              stateManager.notifyListeners();
            },
            configuration: const PlutoGridConfiguration(),
          );
        }),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    required this.stateManager,
    Key? key,
  }) : super(key: key);

  final PlutoGridStateManager stateManager;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final faker_ = fakerimport.Faker();

  int addCount = 1;

  int addedCount = 0;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.stateManager.setSelectingMode(gridSelectingMode);
    });
  }

  void handleAddRows() {
    final newRows = widget.stateManager.getNewRows(count: addCount);
    var count = widget.stateManager.refRows.length + 1;

    for (var e in newRows) {
      e.cells['status']!.value = 'created';
      e.cells['INDEX']!.value = count++;
      e.cells['ID']!.value = count - 1;

      if (widget.stateManager.refRows.isNotEmpty) {
        var output = widget.stateManager.refRows
            .map(
              (element) => element.cells['ID']!.value,
            )
            .toList()
          ..sort();

        print('output : ${output.last ?? 0}');
        if (newRows.last.cells['INDEX']!.value > output.last) {
          e.cells['ID']!.value = newRows.last.cells['INDEX']!.value;
        } else {
          e.cells['ID']!.value = output.last + 1;
        }
        ;
      }

      var updateCell = LicenseModel(
        id: e.cells['ID']!.value,
        lname: e.cells['라이센스']!.value,
        category: e.cells['업무구분']!.value,
        hostname: e.cells['HostName']!.value,
        ip: e.cells['IP']!.value,
        rank: e.cells['등급']!.value,
        cnt: e.cells['보유']!.value,
        pl: e.cells['PL']!.value,
        nuprac: e.cells['NUP RAC']!.value,
        nup: e.cells['NUP']!.value,
        rac: e.cells['RAC']!.value,
        version: e.cells['Version']!.value,
        exp_date: e.cells['만료일']!.value ?? '2024-01-01',
        index: e.cells['INDEX']!.value,
      );
      context.read<LicenseBloc>().add(AddLicense(updateCell));
    }

    widget.stateManager.appendRows(newRows);

    widget.stateManager.setCurrentCell(
      newRows.first.cells.entries.first.value,
      widget.stateManager.refRows.length - 1,
    );

    widget.stateManager.moveScrollByRow(
      PlutoMoveDirection.down,
      widget.stateManager.refRows.length - 2,
    );

    widget.stateManager.setKeepFocus(true);
  }

  void handleSaveAll() {
    widget.stateManager.setShowLoading(true);

    Future.delayed(const Duration(milliseconds: 300), () {
      for (var row in widget.stateManager.refRows) {
        var updateCell = LicenseModel(
          id: row.cells['ID']!.value,
          lname: row.cells['라이센스']!.value,
          category: row.cells['업무구분']!.value,
          hostname: row.cells['HostName']!.value,
          ip: row.cells['IP']!.value,
          rank: row.cells['등급']!.value,
          cnt: row.cells['보유']!.value,
          pl: row.cells['PL']!.value,
          nuprac: row.cells['NUP RAC']!.value,
          nup: row.cells['NUP']!.value,
          rac: row.cells['RAC']!.value,
          version: row.cells['Version']!.value,
          exp_date: row.cells['만료일']!.value ?? '2024-01-01',
          index: row.cells['INDEX']!.value,
        );
        if (row.cells['status']!.value == 'edited') {
          context.read<LicenseBloc>().add(ModifyLicense(updateCell));
          print(updateCell.toJson());
        } else if (row.cells['status']!.value == 'delete') {
          var deleteindex = row.cells['INDEX']!.value - 1;

          print('deleteindex: ${deleteindex} ');
          context.read<LicenseBloc>().add(RemoveLicense(updateCell));
          Future.delayed(const Duration(milliseconds: 600), () {
            widget.stateManager.saveAndDeleteRow(deleteindex);
            var cnt = 1;
            int repeat = widget.stateManager.refRows.length;
            for (var row in widget.stateManager.refRows) {
              if (repeat != -1) {
                row.cells['INDEX']!.value = cnt;
                var updateCell = LicenseModel(
                  id: row.cells['ID']!.value,
                  lname: row.cells['라이센스']!.value,
                  category: row.cells['업무구분']!.value,
                  hostname: row.cells['HostName']!.value,
                  ip: row.cells['IP']!.value,
                  rank: row.cells['등급']!.value,
                  cnt: row.cells['보유']!.value,
                  pl: row.cells['PL']!.value,
                  nuprac: row.cells['NUP RAC']!.value,
                  nup: row.cells['NUP']!.value,
                  rac: row.cells['RAC']!.value,
                  version: row.cells['Version']!.value,
                  exp_date: row.cells['만료일']!.value ?? '2024-01-01',
                  index: cnt,
                );
                context.read<LicenseBloc>().add(ModifyLicense(updateCell));
                cnt++;
                repeat--;
                //DB update
              }
            }
            // widget.stateManager.removeCurrentRow();
          });
        }

        if (row.cells['status']!.value != 'saved') {
          row.cells['status']!.value = 'saved';
        }
      }

      widget.stateManager.setShowLoading(false);
    });
  }

  void handleRemoveCurrentRowButton() {
    widget.stateManager.removeCurrentRow();
    // widget.stateManager.saveAndDeleteRow();
  }

  void handleRemoveSelectedRowsButton() {
    widget.stateManager.removeRows(widget.stateManager.currentSelectingRows);
  }

  void setGridSelectingMode(PlutoGridSelectingMode? mode) {
    if (mode == null || gridSelectingMode == mode) {
      return;
    }

    setState(() {
      gridSelectingMode = mode;
      widget.stateManager.setSelectingMode(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton(
              onPressed: handleAddRows,
              child: const Text('Add rows'),
            ),
            ElevatedButton(
              onPressed: handleSaveAll,
              child: const Text('Save all'),
            ),
            ElevatedButton(
              onPressed: handleRemoveCurrentRowButton,
              child: const Text('Remove Current Row'),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                value: gridSelectingMode,
                items: PlutoGridSelectingMode.values
                    .map<DropdownMenuItem<PlutoGridSelectingMode>>(
                        (PlutoGridSelectingMode item) {
                  final color = gridSelectingMode == item ? Colors.blue : null;

                  return DropdownMenuItem<PlutoGridSelectingMode>(
                    value: item,
                    child: Text(
                      item.name,
                      style: TextStyle(color: color),
                    ),
                  );
                }).toList(),
                onChanged: (PlutoGridSelectingMode? mode) {
                  setGridSelectingMode(mode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
