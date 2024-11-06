// import 'package:flutter/material.dart';
// import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:oneline2/admin_list/feature/page10_EOS_Management/models/eosl_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_bloc.dart';

// class PlutoTableWidget extends StatefulWidget {
//   final List<EoslModel> eoslList;
//   final Function(String) onFilter; // 필터링을 처리할 함수
//   const PlutoTableWidget({
//     super.key,
//     required this.eoslList,
//     required this.onFilter,
//   });

//   @override
//   _PlutoTableWidgetState createState() => _PlutoTableWidgetState();
// }

// class _PlutoTableWidgetState extends State<PlutoTableWidget> {
//   List<PlutoRow> rows = [];
//   late PlutoGridStateManager stateManager;

//   @override
//   void initState() {
//     super.initState();
//     rows = createRows(widget.eoslList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: PlutoGrid(
//         columns: createColumns(),
//         rows: rows,
//         onLoaded: (PlutoGridOnLoadedEvent event) {
//           stateManager = event.stateManager;
//           stateManager.setFilter((PlutoRow row) {
//             return row.cells.values.any((cell) {
//               final value = cell.value.toString().toLowerCase();
//               return value.contains(widget.onFilter(value));
//             });
//           });
//         },
//         configuration: const PlutoGridConfiguration(
//           style: PlutoGridStyleConfig(
//             activatedColor: Colors.tealAccent,
//             gridBorderColor: Colors.teal,
//             gridBackgroundColor: Colors.white,
//             columnTextStyle: TextStyle(
//               color: Colors.teal,
//               fontWeight: FontWeight.bold,
//             ),
//             cellTextStyle: TextStyle(
//               color: Colors.black,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<PlutoColumn> createColumns() {
//     return [
//       PlutoColumn(
//         title: '업무 그룹',
//         field: 'business_group',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: '업무명',
//         field: 'business_name',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: '호스트 이름',
//         field: 'host_name',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: 'IP',
//         field: 'ip_address',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: '플랫폼',
//         field: 'platform',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: '버전',
//         field: 'os_version',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: 'EOSL 날짜',
//         field: 'eosl_date',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: 'EOSL 여부',
//         field: 'is_eosl',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: '태그',
//         field: 'tag',
//         type: PlutoColumnType.text(),
//       ),
//       // PlutoColumn(
//       //   title: '수정',
//       //   field: 'update_button',
//       //   type: PlutoColumnType.text(),
//       //   renderer: (rendererContext) {
//       //     return IconButton(
//       //       icon: const Icon(Icons.edit, color: Colors.blue),
//       //       onPressed: () {
//       //         final row = rendererContext.row;
//       //         _showUpdateEoslDialog(row); // 수정 버튼 클릭 시 Update 다이얼로그
//       //       },
//       //     );
//       //   },
//       // ),
//       // PlutoColumn(
//       //   title: '삭제',
//       //   field: 'delete_button',
//       //   type: PlutoColumnType.text(),
//       //   renderer: (rendererContext) {
//       //     return IconButton(
//       //       icon: const Icon(Icons.delete, color: Colors.red),
//       //       onPressed: () {
//       //         final row = rendererContext.row;
//       //         _deleteEosl(row); // 삭제 버튼을 클릭하면 항목이 삭제됨
//       //       },
//       //     );
//       //   },
//       // ),
//     ];
//   }

//   List<PlutoRow> createRows(List<EoslModel> eoslList) {
//     return eoslList.map((server) {
//       return PlutoRow(
//         cells: {
//           'eosl_no': PlutoCell(value: server.eoslNo ?? ''),
//           'business_group': PlutoCell(value: server.businessGroup ?? ''),
//           'business_name': PlutoCell(value: server.businessName ?? ''),
//           'host_name': PlutoCell(value: server.hostName ?? ''),
//           'ip_address': PlutoCell(value: server.ipAddress ?? ''),
//           'platform': PlutoCell(value: server.platform ?? ''),
//           'os_version': PlutoCell(value: server.osVersion ?? ''),
//           'eosl_date': PlutoCell(value: server.eoslDate ?? ''),
//           'is_eosl': PlutoCell(value: server.isEosl == true ? 'EOSL' : 'No'),
//           'tag': PlutoCell(value: server.tag ?? ''),
//         },
//       );
//     }).toList();
//   }

//   void _showUpdateEoslDialog(PlutoRow row) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String? hostName = row.cells['host_name']?.value;
//         String? businessName = row.cells['business_name']?.value;
//         String? ipAddress = row.cells['ip_address']?.value;
//         String? platform = row.cells['platform']?.value;
//         String? osVersion = row.cells['os_version']?.value;
//         String? eoslDate = row.cells['eosl_date']?.value;
//         String? businessGroup = row.cells['business_group']?.value;
//         String selectedTag = row.cells['tag']?.value ?? '';
//         List<String> existingTags = context
//             .read<EoslBloc>()
//             .state
//             .eoslList
//             .map((eosl) => eosl.tag ?? '')
//             .toSet()
//             .toList();

//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Update EOSL Data'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     TextField(
//                       onChanged: (value) => hostName = value,
//                       controller: TextEditingController(text: hostName),
//                       decoration: const InputDecoration(labelText: '호스트 이름'),
//                     ),
//                     TextField(
//                       onChanged: (value) => businessName = value,
//                       controller: TextEditingController(text: businessName),
//                       decoration: const InputDecoration(labelText: '업무 명'),
//                     ),
//                     TextField(
//                       onChanged: (value) => ipAddress = value,
//                       controller: TextEditingController(text: ipAddress),
//                       decoration: const InputDecoration(labelText: 'IP 주소'),
//                     ),
//                     TextField(
//                       onChanged: (value) => platform = value,
//                       controller: TextEditingController(text: platform),
//                       decoration: const InputDecoration(labelText: '플랫폼'),
//                     ),
//                     TextField(
//                       onChanged: (value) => osVersion = value,
//                       controller: TextEditingController(text: osVersion),
//                       decoration:
//                           const InputDecoration(labelText: 'OS 이름 및 버전'),
//                     ),
//                     TextField(
//                       onChanged: (value) => eoslDate = value,
//                       controller: TextEditingController(text: eoslDate),
//                       decoration: const InputDecoration(
//                           labelText: 'EOSL 날짜 (yyyy-mm-dd)'),
//                     ),
//                     TextField(
//                       onChanged: (value) => businessGroup = value,
//                       controller: TextEditingController(text: businessGroup),
//                       decoration: const InputDecoration(labelText: '업무 그룹'),
//                     ),
//                     DropdownButtonFormField<String>(
//                       value: selectedTag.isNotEmpty ? selectedTag : null,
//                       items: existingTags.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedTag = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () async {
//                     if ([
//                       hostName,
//                       businessName,
//                       ipAddress,
//                       platform,
//                       osVersion,
//                       eoslDate,
//                       businessGroup
//                     ].every(
//                         (element) => element != null && element.isNotEmpty)) {
//                       await context.read<EoslBloc>().apiService.updateEoslData({
//                         'eoslNo': row.cells['eosl_no']?.value,
//                         'hostName': hostName,
//                         'businessName': businessName,
//                         'ipAddress': ipAddress,
//                         'platform': platform,
//                         'osVersion': osVersion,
//                         'eoslDate': eoslDate,
//                         'businessGroup': businessGroup,
//                         'tag': selectedTag,
//                         'isEosl': row.cells['is_eosl']?.value == 'Yes',
//                       });

//                       Navigator.of(context).pop(); // Close dialog
//                       context
//                           .read<EoslBloc>()
//                           .add(FetchEoslList()); // Refresh data
//                     }
//                   },
//                   child: const Text('Update'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close dialog
//                   },
//                   child: const Text('Cancel'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _deleteEosl(PlutoRow row) async {
//     final eoslNo = row.cells['eosl_no']?.value;
//     final confirmation = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Confirmation'),
//           content: const Text('Are you sure you want to delete this item?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true); // Confirm deletion
//               },
//               child: const Text('Delete'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false); // Cancel deletion
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmation == true) {
//       await context.read<EoslBloc>().apiService.deleteEoslData(eoslNo);
//       context.read<EoslBloc>().add(FetchEoslList()); // Refresh data
//     }
//   }
// }
