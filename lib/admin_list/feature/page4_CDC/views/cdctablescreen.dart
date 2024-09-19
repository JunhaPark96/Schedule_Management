import 'dart:convert';
import 'dart:js';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import 'package:oneline2/constants/colors.dart';
import 'package:provider/provider.dart';
import '../view_models/cdcviewmodel.dart';
import '../models/cdcmodel.dart';
import '../repos/cdcrepos.dart';
import '../widgets/vtable.dart';

class CDCTablePage extends StatelessWidget {
  const CDCTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final url = Uri.parse("http://172.26.202.100:8090/get_cdc_call");
    final apiService = ApiService(url);
    return ChangeNotifierProvider(
      create: (context) => CdcViewModel(apiService),
      child: const ExampleApp(),
    );
  }
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: custombackgroundcolorAccent,
      appBar: AppBar(
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              logoutDialoge(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
        title: ElevatedButton(
          onPressed: () {
            Provider.of<CdcViewModel>(context, listen: false).fetchData();
          },
          child: const Text('fetch'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Consumer<CdcViewModel>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return const CircularProgressIndicator();
              } else if (value.errorMessage != null) {
                return Text(value.errorMessage!);
              } else {
                return createTable(value.data);
              }
            },
          ),
        ),
      ),
    );
  }

  VTable<DataModel> createTable(List<DataModel> data) {
    // const disabledStyle =
    //     TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);
    return VTable<DataModel>(
      // items: data.map((table) => SampleRowData(table: table)).toList(),
      items: data,
      tableDescription: '${data.length} items',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: [
        VTableColumn(
          label: 'Table Name',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.table_name,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'ac_grnt_yn',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.ac_grnt_yn,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'im_grnt_yn',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.im_grnt_yn,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'ca_grnt_yn',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.ca_grnt_yn,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'wm_grnt_yn',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.wm_grnt_yn,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'dw_grnt_yn',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.dw_grnt_yn,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'partition_yn',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.partition_yn,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'rgst_dt',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.rgst_dt,
          styleFunction: (row) => null,
        ),
        VTableColumn(
          label: 'Trans Step',
          width: 100,
          grow: 0.1,
          transformFunction: (row) => row.trns_step,
          renderFuntion: (context, data, _) {
            Color color;
            if (data.trns_step == 'P') {
              color = Colors.orange.shade200;
            } else {
              color = Colors.green.shade200;
            }
            return Container(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Stack(children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        data.trns_step,
                      ))
                ]),
                backgroundColor: color,
              ),
            );
          },
        ),
      ],
    );
  }
}
