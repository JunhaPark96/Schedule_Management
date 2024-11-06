import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/models/todo_model.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_bloc.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_event.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/widgets/edit_todo_bottomsheet%20copy.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/widgets/constant.dart';
import 'package:oneline2/constants/colors.dart';

import 'package:oneline2/constants/space.dart';

class ListsTile extends StatelessWidget {
  const ListsTile({
    super.key,
    required this.todo,
  });

  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  todo.title ?? 'Title',
                  style: todo.isCompleted == true
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
                const Spacer(),
                Visibility(
                  visible: todo.isCompleted! ? false : true,
                  child: IconButton(
                      onPressed: () {
                        editTodoBottomSheet(context, todo);
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
                                        .read<TodoBloc>()
                                        .add(RemoveTodo(todo));
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
                  todo.isCompleted! ? 'Completed On :' : 'Create on: ',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(todo.isCompleted! ? todo.updatedAt! : todo.createdAt!),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    final updateMemo = TodoModel(
                      id: todo.id,
                      title: todo.title,
                      description: todo.description,
                      isCompleted: !todo.isCompleted!,
                      createdAt: todo.createdAt,
                      updatedAt:
                          DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
                    );
                    context.read<TodoBloc>().add(ModifyTodo(updateMemo));
                  },
                  child: Icon(
                    todo.isCompleted == true
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                  ),
                ),
                Text(todo.isCompleted == true ? "Completed" : "Progress"),
              ],
            ),
            Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: Row(
                children: [
                  Expanded(
                    child: ExpansionTile(
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
                              todo.description ?? '',
                              style: const TextStyle(
                                  decorationThickness: 3,
                                  decoration: TextDecoration.none),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: todo.description!));
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
