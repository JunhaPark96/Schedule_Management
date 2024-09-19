import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/widgets/add_memo_bottomsheet.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/widgets/edit_memo_bottomsheet.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/models/eos_model.dart';

import 'package:oneline2/admin_list/feature/page7_EOS/view_models/eos_bloc.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/view_models/eos_event.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/view_models/eos_state.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/widgets/constant.dart';

import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import 'package:oneline2/constants/colors.dart';
import 'package:oneline2/constants/gaps.dart';
import 'package:oneline2/constants/space.dart';
import 'package:oneline2/constants/util/custom_widgets/custom_elevated_button.dart';
import 'package:oneline2/constants/util/custom_widgets/custom_textfromfiled.dart';

import '../widgets/global_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class EOSChartScreen extends StatefulWidget {
  const EOSChartScreen({super.key});

  @override
  State<EOSChartScreen> createState() => _EOSChartScreenState();
}

class _EOSChartScreenState extends State<EOSChartScreen> {
  final _globalWidget = GlobalWidget();

  Future<dynamic> addeosBottomSheet(BuildContext context) {
    TextEditingController swController = TextEditingController();
    TextEditingController versionController = TextEditingController();
    TextEditingController startdtController = TextEditingController();
    TextEditingController enddtController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    TextEditingController memoController = TextEditingController();
    DateTime? selectedEndDate;

    Future<void> _selectEndDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2090));
      setState(() {
        selectedEndDate = picked;
      });
      print(selectedEndDate);
    }

    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocBuilder<EOSBloc, EOSState>(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add EOS',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextFormField(
                                width: constraints.maxWidth / 4.5,
                                hintText: 'Sw Name',
                                controller: swController,
                                keyboardType: TextInputType.text,
                              ),
                              Gaps.h5,
                              CustomTextFormField(
                                width: constraints.maxWidth / 4.5,
                                keyboardType: TextInputType.multiline,
                                hintText: 'Version',
                                controller: versionController,
                              ),
                              Gaps.h5,
                              CustomTextFormField(
                                width: constraints.maxWidth / 4.5,
                                keyboardType: TextInputType.multiline,
                                hintText: 'Code',
                                controller: codeController,
                              ),
                              Gaps.h5,
                              CustomTextFormField(
                                width: constraints.maxWidth / 4.5,
                                keyboardType: TextInputType.multiline,
                                hintText: 'Memo',
                                controller: memoController,
                              ),
                            ],
                          ),
                          Gaps.v5,
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onPressed: () => _selectEndDate(context),
                              child: Text('End Date')),
                          Gaps.v5,
                          CustomElevatedButton(
                            buttonLabel: 'Add EOS',
                            onPressed: () {
                              final addEOS = EOSModel(
                                  sw: swController.text,
                                  version: versionController.text,
                                  startdt: DateTime.now(),
                                  enddt: selectedEndDate ?? DateTime.now(),
                                  code: codeController.text,
                                  memo: memoController.text,
                                  id: '');
                              context.read<EOSBloc>().add(AddEOS(addEOS));
                              swController.clear();
                              versionController.clear();
                              startdtController.clear();
                              enddtController.clear();
                              codeController.clear();
                              memoController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<dynamic> editeosBottomSheet(BuildContext context) {
    TextEditingController swController = TextEditingController();
    TextEditingController versionController = TextEditingController();
    TextEditingController startdtController = TextEditingController();
    TextEditingController enddtController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    TextEditingController memoController = TextEditingController();
    DateTime? selectedEndDate;
    Future<void> _selectEndDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2090));
      setState(() {
        selectedEndDate = picked;
      });
      print(selectedEndDate);
    }

    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocBuilder<EOSBloc, EOSState>(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit Eos',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton(
                                hint: const Text('Select SW'),
                                icon: Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                autofocus: true,
                                underline: Container(
                                  height: 2,
                                  color: Colors.blueAccent,
                                ),
                                value: state.filterlist
                                        .map((model) => model.sw)
                                        .contains(state.selectedsw)
                                    ? state.selectedsw
                                    : state.filterlist.first.sw,
                                onChanged: (newvalue) {
                                  context
                                      .read<EOSBloc>()
                                      .add(selectSw(newvalue!));
                                  print(newvalue);
                                },
                                items: state.filterlist.map((model) {
                                  return DropdownMenuItem(
                                    child: Text(model.sw!),
                                    value: model.sw,
                                  );
                                }).toList(),
                              ),
                              Gaps.h5,
                              CustomTextFormField(
                                width: constraints.maxWidth / 4.5,
                                keyboardType: TextInputType.multiline,
                                hintText: 'Version',
                                controller: versionController,
                              ),
                              Gaps.h5,
                              CustomTextFormField(
                                width: constraints.maxWidth / 4.5,
                                keyboardType: TextInputType.multiline,
                                hintText: 'Code',
                                controller: codeController,
                              ),
                              Gaps.h5,
                              CustomTextFormField(
                                width: constraints.maxWidth / 4.5,
                                keyboardType: TextInputType.multiline,
                                hintText: 'Memo',
                                controller: memoController,
                              ),
                            ],
                          ),
                          Gaps.v5,
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onPressed: () => _selectEndDate(context),
                              child: Text('End Date')),
                          Gaps.v5,
                          CustomElevatedButton(
                            buttonLabel: 'Edit Memo',
                            onPressed: () {
                              final editEOS = EOSModel(
                                sw: state.selectedsw,
                                version: versionController.text,
                                startdt: DateTime.now(),
                                enddt: selectedEndDate ?? DateTime.now(),
                                code: codeController.text,
                                memo: memoController.text,
                                id: '',
                              );
                              context.read<EOSBloc>().add(ModifyEOS(editEOS));
                              swController.clear();
                              versionController.clear();
                              startdtController.clear();
                              enddtController.clear();
                              codeController.clear();
                              memoController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<dynamic> removeeosBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocBuilder<EOSBloc, EOSState>(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Remove Eos',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        DropdownButton(
                          value: state.filterlist
                                  .map((model) => model.sw)
                                  .contains(state.selectedsw)
                              ? state.selectedsw
                              : state.filterlist.first.sw,
                          onChanged: (newvalue) {
                            context.read<EOSBloc>().add(selectSw(newvalue!));
                            print(newvalue);
                          },
                          items: state.filterlist.map((model) {
                            return DropdownMenuItem(
                              child: Text(model.sw!),
                              value: model.sw,
                            );
                          }).toList(),
                        ),
                        CustomElevatedButton(
                          buttonLabel: 'Remove EOS',
                          onPressed: () {
                            final removeEOS = EOSModel(
                              sw: state.selectedsw,
                              version: 'version',
                              startdt: DateTime.now(),
                              enddt: DateTime.now(),
                              code: ' ',
                              memo: ' ',
                              id: ' ',
                            );
                            context.read<EOSBloc>().add(RemoveEOS(removeEOS));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController searchController = TextEditingController();
  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('EOS List'),
        elevation: 1,
        actions: [
          AnimatedContainer(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 200),
            width: _folded ? 150 : 250,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
              boxShadow: kElevationToShadow[6],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Column(
                  children: [
                    Gaps.v10,
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_folded ? 24 : 0),
                          topRight: const Radius.circular(24),
                          bottomLeft: Radius.circular(_folded ? 24 : 0),
                          bottomRight: const Radius.circular(24),
                        ),
                        child: Icon(_folded ? Icons.search : Icons.close),
                      ),
                    ),
                  ],
                ),
                prefixIconColor: Colors.teal.shade200,
                border: InputBorder.none,
              ),
              onTap: () {
                setState(() {
                  _folded = !_folded;
                });
              },
              onChanged: (query) {
                // print(query);
                context.read<EOSBloc>().add(FilterEOS(query));
              },
            ),
          ),
          IconButton(
            onPressed: () async {
              logoutDialoge(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: BlocConsumer<EOSBloc, EOSState>(
        listener: (context, state) {},
        builder: (context, state) {
          print('state.eoslist!: ${state.eoslist}');
          return Column(
            children: [
              Gaps.v10,
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _globalWidget.createDetailWidget(
                        title: 'EOS Chart', desc: 'Check End of Software'),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: SfCartesianChart(
                        primaryXAxis: const CategoryAxis(),
                        primaryYAxis: DateTimeAxis(
                          minimum: DateTime(2023, 1, 01),
                          maximum: DateTime(2030, 12, 01),
                          dateFormat: DateFormat('yyyy-MM'),
                        ),
                        // tooltipBehavior: TooltipBehavior(
                        //   textAlignment: ChartAlignment.near,
                        //   elevation: 10,
                        //   enable: true,
                        //   shadowColor: Colors.green,
                        //   activationMode: ActivationMode.singleTap,
                        //   animationDuration: 350,
                        //   borderColor: Colors.transparent,
                        //   // borderWidth: 1,
                        //   // decimalPlaces: 3,
                        //   tooltipPosition: TooltipPosition.pointer,
                        //   // builder:
                        //   //     (data, point, series, pointIndex, seriesIndex) {
                        //   //   final EOSModel eosData =
                        //   //       state.filterlist[pointIndex];
                        //   //   return Container(
                        //   //     padding: const EdgeInsetsDirectional.all(12),
                        //   //     decoration: BoxDecoration(
                        //   //       boxShadow: const [
                        //   //         BoxShadow(
                        //   //           color: Colors.black,
                        //   //           blurRadius: 2.0,
                        //   //           offset: Offset(2, 2),
                        //   //         ),
                        //   //       ],
                        //   //       borderRadius: BorderRadius.circular(8),
                        //   //     ),
                        //   //     child: Column(
                        //   //       crossAxisAlignment: CrossAxisAlignment.start,
                        //   //       mainAxisSize: MainAxisSize.min,
                        //   //       children: [
                        //   //         Text(
                        //   //           '${eosData.sw}',
                        //   //           style: const TextStyle(
                        //   //               color: Colors.white,
                        //   //               fontSize: 14,
                        //   //               fontWeight: FontWeight.bold),
                        //   //         ),
                        //   //         const SizedBox(height: 4),
                        //   //         Text(
                        //   //           'End Date: ${DateFormat('yyyy/MM/dd').format(eosData.enddt!)}',
                        //   //           style: const TextStyle(
                        //   //               color: Colors.white,
                        //   //               fontSize: 12,
                        //   //               fontWeight: FontWeight.bold),
                        //   //         ),
                        //   //       ],
                        //   //     ),
                        //   //   );
                        //   // },
                        // ),
                        series: <CartesianSeries<EOSModel, String>>[
                          StackedBarSeries<EOSModel, String>(
                            animationDuration: 400,
                            groupName: 'Sw',
                            dataSource: state.filterlist,
                            xValueMapper: (EOSModel data, _) => data.sw,
                            yValueMapper: (EOSModel data, _) =>
                                data.enddt!.millisecondsSinceEpoch.toDouble(),
                            name: 'EOS',
                          ),
                          // StackedBarSeries<EOS, String>(
                          //   groupName: 'extend',
                          //   dataSource: _data,
                          //   xValueMapper: (EOS data, _) => data.sw,
                          //   yValueMapper: (EOS data, _) =>
                          //       data.extend.millisecondsSinceEpoch,
                          //   name: 'extend',
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<EOSBloc, EOSState>(builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: custombackgroundcolorAccent,
              label: const Text(
                'Add EOS',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                addeosBottomSheet(context);
              },
            ),
            FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: custombackgroundcolorAccent,
              label: const Text(
                'Edit EOS',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                editeosBottomSheet(context);
              },
            ),
            FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: custombackgroundcolorAccent,
              label: const Text(
                'Remove EOS',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                removeeosBottomSheet(context);
              },
            ),
          ],
        );
      }),
    );
  }
}
