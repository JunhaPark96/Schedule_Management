import 'dart:js_interop';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:faker/faker.dart' as fakerimport;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:collection/collection.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/lib/src/model/pluto_column_type.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/model/cdc_model.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/view_models/cdc_bloc.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/view_models/cdc_event.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/view_models/cdc_state.dart';
import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import '../repos/cdc_repos.dart';
import '../lib/pluto_grid.dart';

class CdcTable extends StatefulWidget {
  const CdcTable({super.key});

  @override
  State<CdcTable> createState() => _CdcTableState();
}

class _CdcTableState extends State<CdcTable> {
  void setColumnSizeConfig(PlutoGridColumnSizeConfig config) {
    stateManager.setColumnSizeConfig(config);
  }

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
          width: 60),
      PlutoColumn(
        title: 'OWNER',
        field: 'owner',
        type: PlutoColumnType.text(),
        width: 80,
      ),
      PlutoColumn(
        title: 'TABLE_NAME',
        field: 'table_name',
        frozen: PlutoColumnFrozen.start,
        type: PlutoColumnType.text(),
        minWidth: 90,
        width: 90,
      ),
      PlutoColumn(
        title: 'AC_GRNT_YN',
        field: 'ac_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'IM_GRNT_YN',
        field: 'im_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'CA_GRNT_YN',
        field: 'ca_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'WM_GRNT_YN',
        field: 'wm_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'DW_GRNT_YN',
        field: 'dw_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'RD_GRNT_YN',
        field: 'rd_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'PE_GRNT_YN',
        field: 'pe_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'BP_GRNT_YN',
        field: 'bp_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'ECUBE_GRNT_YN',
        field: 'ecube_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'ECUBEEBM_GRNT_YN',
        field: 'ecubeebm_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'AL_GRNT_YN',
        field: 'al_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'PM_GRNT_YN',
        field: 'pm_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'CS_GRNT_YN',
        field: 'cs_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'BK_GRNT_YN',
        field: 'bk_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'AM_GRNT_YN',
        field: 'am_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'RP_GRNT_YN',
        field: 'rp_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'UM_GRNT_YN',
        field: 'um_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'IB_GRNT_YN',
        field: 'ib_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'IX_GRNT_YN',
        field: 'ix_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'PS_GRNT_YN',
        field: 'ps_grnt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'LOG_TBL_CRT_YN',
        field: 'log_tbl_crt_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'LOG_TBL_BIZ_OWNR',
        field: 'log_tbl_biz_ownr',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'TBL_LAYOUT_COPY_YN',
        field: 'tbl_layout_copy_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'CHRG_JOB',
        field: 'chrg_job',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'LOAD_DVSN',
        field: 'load_dvsn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'RGST_DT',
        field: 'rgst_dt',
        minWidth: 100,
        frozen: PlutoColumnFrozen.end,
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: 'DATA_CSTD_STDR_DT',
        field: 'data_cstd_stdr_dt',
        type: PlutoColumnType.text(),
        width: 100,
      ),
      PlutoColumn(
        title: 'PARTITION_YN',
        field: 'partition_yn',
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        title: 'TRNS_STEP',
        field: 'trns_step',
        frozen: PlutoColumnFrozen.end,
        type: PlutoColumnType.text(),
        width: 60,
      ),
      PlutoColumn(
        minWidth: 90,
        width: 90,
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

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CDC List'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              logoutDialoge(context);
            },
            icon: const Icon(Icons.logout),
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: const Text('fetch'),
          // ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CdcBloc, CdcState>(builder: (context, state) {
          final List<PlutoRow> FetchedRows = state.prow;
          List<PlutoRow> rows = [];
          Future<PlutoLazyPaginationResponse> fetch(
            PlutoLazyPaginationRequest request,
          ) async {
            List<PlutoRow> tempList = FetchedRows;
            // print('=-=-=-=-=-=');
            // print('filterRows');
            // print(request.filterRows);

            // print('=-=-=-=-=-=');
            // print('tempList');
            // print(tempList.map(
            //   (e) => e.cells['INDEX']!.value,
            // ));

            // If you have a filtering state,
            // you need to implement it so that the user gets data from the server
            // according to the filtering state.
            //
            // request.page is 1 when the filtering state changes.
            // This is because, when the filtering state is changed,
            // the first page must be loaded with the new filtering applied.
            //
            // request.filterRows is a List<PlutoRow> type containing filtering information.
            // To convert to Map type, you can do as follows.
            //
            // FilterHelper.convertRowsToMap(request.filterRows);
            //
            // When the filter of abc is applied as Contains type to column2
            // and 123 as Contains type to column3, for example
            // It is returned as below.
            // {column2: [{Contains: 123}], column3: [{Contains: abc}]}
            //
            // If multiple filtering conditions are set in one column,
            // multiple conditions are included as shown below.
            // {column2: [{Contains: abc}, {Contains: 123}]}
            //
            // The filter type in FilterHelper.defaultFilters is the default,
            // If there is user-defined filtering,
            // the title set by the user is returned as the filtering type.
            // All filtering can change the value returned as a filtering type by changing the name property.
            // In case of PlutoFilterTypeContains filter, if you change the static type name to include
            // PlutoFilterTypeContains.name = 'include';
            // {column2: [{include: abc}, {include: 123}]} will be returned.
            if (request.filterRows.isNotEmpty) {
              final filter = FilterHelper.convertRowsToFilter(
                request.filterRows,
                stateManager.refColumns,
              );

              tempList = FetchedRows.where(filter!).toList();
            }

            print('=-=-=-=-=-=');
            print('tempList');
            print(tempList.map(
              (e) => e.cells['INDEX']!.value,
            ));

            // If there is a sort state,
            // you need to implement it so that the user gets data from the server
            // according to the sort state.
            //
            // request.page is 1 when the sort state changes.
            // This is because when the sort state changes,
            // new data to which the sort state is applied must be loaded.
            if (request.sortColumn != null &&
                !request.sortColumn!.sort.isNone) {
              tempList = [...tempList];

              tempList.sort((a, b) {
                final sortA = request.sortColumn!.sort.isAscending ? a : b;
                final sortB = request.sortColumn!.sort.isAscending ? b : a;

                return request.sortColumn!.type.compare(
                  sortA.cells[request.sortColumn!.field]!.valueForSorting,
                  sortB.cells[request.sortColumn!.field]!.valueForSorting,
                );
              });
            }

            final page = request.page;
            const pageSize = 100;
            final totalPage = (tempList.length / pageSize).ceil();
            final start = (page - 1) * pageSize;
            final end = start + pageSize;

            Iterable<PlutoRow> fetchedRows = tempList.getRange(
              max(0, start),
              min(tempList.length, end),
            );

            await Future.delayed(const Duration(milliseconds: 500));

            return Future.value(PlutoLazyPaginationResponse(
              totalPage: totalPage,
              rows: fetchedRows.toList(),
            ));
          }

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
            rows: rows,
            // rows: state.prow,
            // columnGroups: columnGroups,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
              stateManager.setShowColumnFilter(true);
            },
            createHeader: (stateManager) => _Header(
              stateManager: stateManager,
              setConfig: setColumnSizeConfig,
            ),
            onChanged: (PlutoGridOnChangedEvent event) {
              if (event.row.cells['status']!.value == 'saved' ||
                  event.row.cells['status']!.value == 'created') {
                event.row.cells['status']!.value = 'edited';
              }
              print('event : ${event}');

              stateManager.notifyListeners();
            },
            configuration: const PlutoGridConfiguration(
              columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.none,
                resizeMode: PlutoResizeMode.normal,
              ),
            ),
            createFooter: (stateManager) {
              return PlutoLazyPagination(
                // Determine the first page.
                // Default is 1.
                initialPage: 1,

                // First call the fetch function to determine whether to load the page.
                // Default is true.
                initialFetch: true,

                // Decide whether sorting will be handled by the server.
                // If false, handle sorting on the client side.
                // Default is true.
                fetchWithSorting: true,

                // Decide whether filtering is handled by the server.
                // If false, handle filtering on the client side.
                // Default is true.
                fetchWithFiltering: true,

                // Determines the page size to move to the previous and next page buttons.
                // Default value is null. In this case,
                // it moves as many as the number of page buttons visible on the screen.
                pageSizeToMove: null,
                fetch: fetch,
                stateManager: stateManager,
              );
            },
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
    required this.setConfig,
  }) : super(key: key);

  final PlutoGridStateManager stateManager;
  final void Function(PlutoGridColumnSizeConfig) setConfig;
  @override
  State<_Header> createState() => _HeaderState();
}

enum _RestoreAutoSizeOptions {
  restoreAutoSizeAfterHideColumn,
  restoreAutoSizeAfterFrozenColumn,
  restoreAutoSizeAfterMoveColumn,
  restoreAutoSizeAfterInsertColumn,
  restoreAutoSizeAfterRemoveColumn,
}

class _HeaderState extends State<_Header> {
  PlutoGridColumnSizeConfig columnSizeConfig =
      const PlutoGridColumnSizeConfig();
  final faker = fakerimport.Faker();

  int addCount = 1;

  int addedCount = 0;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    super.initState();
    final Map<_RestoreAutoSizeOptions, bool> restoreOptions = {};

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.stateManager.setSelectingMode(gridSelectingMode);
    });

    restoreOptions[_RestoreAutoSizeOptions.restoreAutoSizeAfterHideColumn] =
        columnSizeConfig.restoreAutoSizeAfterHideColumn;
    restoreOptions[_RestoreAutoSizeOptions.restoreAutoSizeAfterFrozenColumn] =
        columnSizeConfig.restoreAutoSizeAfterFrozenColumn;
    restoreOptions[_RestoreAutoSizeOptions.restoreAutoSizeAfterMoveColumn] =
        columnSizeConfig.restoreAutoSizeAfterMoveColumn;
    restoreOptions[_RestoreAutoSizeOptions.restoreAutoSizeAfterInsertColumn] =
        columnSizeConfig.restoreAutoSizeAfterInsertColumn;
    restoreOptions[_RestoreAutoSizeOptions.restoreAutoSizeAfterRemoveColumn] =
        columnSizeConfig.restoreAutoSizeAfterRemoveColumn;
  }

  void _setAutoSize(PlutoAutoSizeMode mode) {
    setState(() {
      columnSizeConfig = columnSizeConfig.copyWith(
        autoSizeMode: mode,
      );
      widget.setConfig(columnSizeConfig);
    });
  }

  void _handleAutoSizeNone() {
    _setAutoSize(PlutoAutoSizeMode.none);
  }

  void _handleAutoSizeEqual() {
    _setAutoSize(PlutoAutoSizeMode.equal);
  }

  void _handleAutoSizeScale() {
    _setAutoSize(PlutoAutoSizeMode.scale);
  }

  void handleAddRows() {
    final newRows = widget.stateManager.getNewRows(count: addCount);
    var count = widget.stateManager.refRows.length + 1;

    for (var e in newRows) {
      e.cells['status']!.value = 'created';
      e.cells['INDEX']!.value = count++;
      // e.cells['ID']!.value = count - 1;
      e.cells['ID']!.value = widget.stateManager.refRows.length;

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

      var updateCell = CdcModel(
          id: e.cells['ID']!.value,
          index: e.cells["INDEX"]!.value,
          owner: e.cells['owner']!.value,
          table_name: e.cells['table_name']!.value,
          ac_grnt_yn: e.cells['ac_grnt_yn']!.value,
          im_grnt_yn: e.cells['im_grnt_yn']!.value,
          ca_grnt_yn: e.cells['ca_grnt_yn']!.value,
          wm_grnt_yn: e.cells['wm_grnt_yn']!.value,
          dw_grnt_yn: e.cells['dw_grnt_yn']!.value,
          rd_grnt_yn: e.cells['rd_grnt_yn']!.value,
          pe_grnt_yn: e.cells['pe_grnt_yn']!.value,
          bp_grnt_yn: e.cells['bp_grnt_yn']!.value,
          ecube_grnt_yn: e.cells['ecube_grnt_yn']!.value,
          ecubeebm_grnt_yn: e.cells['ecubeebm_grnt_yn']!.value,
          al_grnt_yn: e.cells['al_grnt_yn']!.value,
          pm_grnt_yn: e.cells['pm_grnt_yn']!.value,
          cs_grnt_yn: e.cells['cs_grnt_yn']!.value,
          bk_grnt_yn: e.cells['bk_grnt_yn']!.value,
          am_grnt_yn: e.cells['am_grnt_yn']!.value,
          rp_grnt_yn: e.cells['rp_grnt_yn']!.value,
          um_grnt_yn: e.cells['um_grnt_yn']!.value,
          ib_grnt_yn: e.cells['ib_grnt_yn']!.value,
          ix_grnt_yn: e.cells['ix_grnt_yn']!.value,
          ps_grnt_yn: e.cells['ps_grnt_yn']!.value,
          log_tbl_crt_yn: e.cells['log_tbl_crt_yn']!.value,
          log_tbl_biz_ownr: e.cells['log_tbl_biz_ownr']!.value,
          tbl_layout_copy_yn: e.cells['tbl_layout_copy_yn']!.value,
          chrg_job: e.cells['chrg_job']!.value,
          load_dvsn: e.cells['load_dvsn']!.value,
          rgst_dt: e.cells['rgst_dt']!.value,
          data_cstd_stdr_dt: e.cells['data_cstd_stdr_dt']!.value,
          partition_yn: e.cells['partition_yn']!.value,
          trns_step: e.cells['trns_step']!.value);

      context.read<CdcBloc>().add(AddCdc(updateCell));
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
        var updateCell = CdcModel(
            id: row.cells['ID']!.value,
            index: row.cells["INDEX"]!.value,
            owner: row.cells['owner']!.value,
            table_name: row.cells['table_name']!.value,
            ac_grnt_yn: row.cells['ac_grnt_yn']!.value,
            im_grnt_yn: row.cells['im_grnt_yn']!.value,
            ca_grnt_yn: row.cells['ca_grnt_yn']!.value,
            wm_grnt_yn: row.cells['wm_grnt_yn']!.value,
            dw_grnt_yn: row.cells['dw_grnt_yn']!.value,
            rd_grnt_yn: row.cells['rd_grnt_yn']!.value,
            pe_grnt_yn: row.cells['pe_grnt_yn']!.value,
            bp_grnt_yn: row.cells['bp_grnt_yn']!.value,
            ecube_grnt_yn: row.cells['ecube_grnt_yn']!.value,
            ecubeebm_grnt_yn: row.cells['ecubeebm_grnt_yn']!.value,
            al_grnt_yn: row.cells['al_grnt_yn']!.value,
            pm_grnt_yn: row.cells['pm_grnt_yn']!.value,
            cs_grnt_yn: row.cells['cs_grnt_yn']!.value,
            bk_grnt_yn: row.cells['bk_grnt_yn']!.value,
            am_grnt_yn: row.cells['am_grnt_yn']!.value,
            rp_grnt_yn: row.cells['rp_grnt_yn']!.value,
            um_grnt_yn: row.cells['um_grnt_yn']!.value,
            ib_grnt_yn: row.cells['ib_grnt_yn']!.value,
            ix_grnt_yn: row.cells['ix_grnt_yn']!.value,
            ps_grnt_yn: row.cells['ps_grnt_yn']!.value,
            log_tbl_crt_yn: row.cells['log_tbl_crt_yn']!.value,
            log_tbl_biz_ownr: row.cells['log_tbl_biz_ownr']!.value,
            tbl_layout_copy_yn: row.cells['tbl_layout_copy_yn']!.value,
            chrg_job: row.cells['chrg_job']!.value,
            load_dvsn: row.cells['load_dvsn']!.value,
            rgst_dt: row.cells['rgst_dt']!.value,
            data_cstd_stdr_dt: row.cells['data_cstd_stdr_dt']!.value,
            partition_yn: row.cells['partition_yn']!.value,
            trns_step: row.cells['trns_step']!.value);
        if (row.cells['status']!.value == 'edited') {
          context.read<CdcBloc>().add(ModifyCdc(updateCell));
          print(updateCell.toJson());
        } else if (row.cells['status']!.value == 'delete') {
          var deleteindex = row.cells['INDEX']!.value - 1;

          print('deleteindex: ${deleteindex} ');
          context.read<CdcBloc>().add(RemoveCdc(updateCell));
          Future.delayed(const Duration(milliseconds: 600), () {
            widget.stateManager.saveAndDeleteRow(deleteindex);
            var cnt = 1;
            int repeat = widget.stateManager.refRows.length;
            for (var row in widget.stateManager.refRows) {
              if (repeat != -1) {
                row.cells['INDEX']!.value = cnt;
                var updateCell = CdcModel(
                  id: row.cells['ID']!.value,
                  index: row.cells["INDEX"]!.value,
                  owner: row.cells['owner']!.value,
                  table_name: row.cells['table_name']!.value,
                  ac_grnt_yn: row.cells['ac_grnt_yn']!.value,
                  im_grnt_yn: row.cells['im_grnt_yn']!.value,
                  ca_grnt_yn: row.cells['ca_grnt_yn']!.value,
                  wm_grnt_yn: row.cells['wm_grnt_yn']!.value,
                  dw_grnt_yn: row.cells['dw_grnt_yn']!.value,
                  rd_grnt_yn: row.cells['rd_grnt_yn']!.value,
                  pe_grnt_yn: row.cells['pe_grnt_yn']!.value,
                  bp_grnt_yn: row.cells['bp_grnt_yn']!.value,
                  ecube_grnt_yn: row.cells['ecube_grnt_yn']!.value,
                  ecubeebm_grnt_yn: row.cells['ecubeebm_grnt_yn']!.value,
                  al_grnt_yn: row.cells['al_grnt_yn']!.value,
                  pm_grnt_yn: row.cells['pm_grnt_yn']!.value,
                  cs_grnt_yn: row.cells['cs_grnt_yn']!.value,
                  bk_grnt_yn: row.cells['bk_grnt_yn']!.value,
                  am_grnt_yn: row.cells['am_grnt_yn']!.value,
                  rp_grnt_yn: row.cells['rp_grnt_yn']!.value,
                  um_grnt_yn: row.cells['um_grnt_yn']!.value,
                  ib_grnt_yn: row.cells['ib_grnt_yn']!.value,
                  ix_grnt_yn: row.cells['ix_grnt_yn']!.value,
                  ps_grnt_yn: row.cells['ps_grnt_yn']!.value,
                  log_tbl_crt_yn: row.cells['log_tbl_crt_yn']!.value,
                  log_tbl_biz_ownr: row.cells['log_tbl_biz_ownr']!.value,
                  tbl_layout_copy_yn: row.cells['tbl_layout_copy_yn']!.value,
                  chrg_job: row.cells['chrg_job']!.value,
                  load_dvsn: row.cells['load_dvsn']!.value,
                  rgst_dt: row.cells['rgst_dt']!.value,
                  data_cstd_stdr_dt: row.cells['data_cstd_stdr_dt']!.value,
                  partition_yn: row.cells['partition_yn']!.value,
                  trns_step: row.cells['trns_step']!.value,
                );

                context.read<CdcBloc>().add(ModifyCdc(updateCell));
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
              style: ElevatedButton.styleFrom(
                backgroundColor: columnSizeConfig.autoSizeMode.isNone
                    ? Colors.blue
                    : Colors.grey,
              ),
              onPressed: _handleAutoSizeNone,
              child: const Text('AutoSize none'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: columnSizeConfig.autoSizeMode.isEqual
                    ? Colors.blue
                    : Colors.grey,
              ),
              onPressed: _handleAutoSizeEqual,
              child: const Text('AutoSize equal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: columnSizeConfig.autoSizeMode.isScale
                    ? Colors.blue
                    : Colors.grey,
              ),
              onPressed: _handleAutoSizeScale,
              child: const Text('AutoSize scale'),
            ),
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
