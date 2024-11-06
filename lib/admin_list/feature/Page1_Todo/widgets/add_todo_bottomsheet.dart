import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:oneline2/admin_list/feature/Page1_Todo/models/todo_model.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_bloc.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_event.dart';
import 'package:oneline2/constants/util/custom_widgets/custom_elevated_button.dart';
import 'package:oneline2/constants/util/custom_widgets/custom_textfromfiled.dart';

Future<dynamic> addTodoBottomSheet(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  return showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          'Add Todo',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    CustomTextFormField(
                      hintText: 'Title',
                      controller: titleController,
                      keyboardType: TextInputType.text,
                    ),
                    CustomTextFormField(
                      keyboardType: TextInputType.multiline,
                      hintText: 'Desctiption',
                      controller: descController,
                      maxlines: 7,
                    ),
                    CustomElevatedButton(
                      buttonLabel: 'Add Todo',
                      onPressed: () {
                        final addTodo = TodoModel(
                          id: 'tempid',
                          title: titleController.text,
                          description: descController.text,
                          isCompleted: false,
                          createdAt: '',
                          updatedAt: '',
                        );
                        context.read<TodoBloc>().add(AddTodo(addTodo));
                        titleController.clear();
                        descController.clear();
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
    },
  );
}
