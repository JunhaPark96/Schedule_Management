import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oneline2/admin_list/feature/Page5_Memo/models/memo_model.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_bloc.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_event.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/widgets/edit_memo_bottomsheet.dart';
import 'package:oneline2/constants/space.dart';

class ListsTile extends StatelessWidget {
  const ListsTile({
    super.key,
    required this.memo,
  });

  final MemoModel memo;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  memo.title ?? 'Title',
                  style: memo.isCompleted == true
                      ? const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          decorationColor: Colors.red,
                          decorationThickness: 2,
                          decoration: TextDecoration.lineThrough)
                      : const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          decorationThickness: 3,
                          decoration: TextDecoration.none),
                ),

                // Text(memo.id!),
                const Spacer(),
                Visibility(
                  visible: memo.isCompleted! ? false : true,
                  child: IconButton(
                      onPressed: () {
                        editmemoBottomSheet(context, memo);
                      },
                      icon: const Icon(Icons.mode)),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: RichText(
                            text: const TextSpan(
                                text: "If you want to Delete, click ",
                                style: TextStyle(color: Colors.black),
                                children: [
                              TextSpan(
                                  text: " Confirm ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black)),
                              TextSpan(text: 'else click'),
                              TextSpan(
                                  text: ' Cancel ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black))
                            ])),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: () async {
                                Future.delayed(
                                  const Duration(microseconds: 500),
                                  () {
                                    context
                                        .read<MemoBloc>()
                                        .add(RemoveMemo(memo));
                                  },
                                );
                                Navigator.of(context).pop();
                              },
                              child: const Text('Confirm'))
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
            Space.y(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.calendar_month,
                ),
                Text(
                  memo.isCompleted! ? 'Completed On :' : 'Create on: ',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(memo.isCompleted! ? memo.updatedAt! : memo.createdAt!),
              ],
            ),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            // GestureDetector(
            //   onTap: () {
            //     final updatememo = MemoModel(
            //       id: memo.id,
            //       title: memo.title,
            //       description: memo.description,
            //       isCompleted: !memo.isCompleted!,
            //       createdAt: memo.createdAt,
            //       updatedAt:
            //           DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
            //     );
            //     context.read<MemoBloc>().add(ModifyMemo(updatememo));
            //   },
            //   child: Icon(
            //     memo.isCompleted == true
            //         ? Icons.check_box_outlined
            //         : Icons.check_box_outline_blank,
            //   ),
            // ),
            // Text(memo.isCompleted == true ? "Completed" : "Progress"),
            //   ],
            // ),
            Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: Row(
                children: [
                  Expanded(
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      expandedAlignment: Alignment.topLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      tilePadding: EdgeInsets.zero,
                      title: const Text(
                        'Description',
                        style: TextStyle(fontSize: 13),
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText(
                              memo.description ?? '',
                              style: const TextStyle(
                                  decorationThickness: 3,
                                  decoration: TextDecoration.none),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: memo.description!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Copied to Clipboard')));
                                },
                                child: const Icon(Icons.copy)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
