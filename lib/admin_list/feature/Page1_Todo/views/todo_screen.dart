import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_bloc.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_event.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_state.dart';

import 'package:oneline2/admin_list/feature/Page1_Todo/widgets/add_todo_bottomsheet.dart';

import 'package:oneline2/admin_list/feature/Page1_Todo/widgets/lists_tile.dart';
import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import 'package:oneline2/constants/colors.dart';
import 'package:oneline2/constants/gaps.dart';
import 'package:oneline2/constants/sizes.dart';

import 'package:oneline2/constants/space.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController searchController = TextEditingController();
  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Todo List',
          ),
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
                  context.read<TodoBloc>().add(FilterTodos(query));
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                logoutDialoge(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(tabs: [
            Tab(
              text: "Todo's",
            ),
            Tab(
              text: "Completed",
            )
          ]),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Gaps.v10,
                Expanded(
                  child: BlocConsumer<TodoBloc, TodoState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.loading) {
                        return Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: Colors.blue, size: Sizes.size24));
                      } else if (state.error.isNotEmpty) {
                        Center(
                          child: Text('Error: ${state.error}'),
                        );
                      } else if (state.todolist.isEmpty) {
                        const Center(
                          child: Text('No Data'),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Space.y(10),
                          itemCount: state.filterlist.length,
                          itemBuilder: (context, index) {
                            final todo = state.filterlist[index];
                            return ListsTile(todo: todo);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Gaps.v10,
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
                      context.read<TodoBloc>().add(FilterTodos(query));
                    },
                  ),
                ),
                Expanded(
                  child: BlocConsumer<TodoBloc, TodoState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.loading) {
                        return Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: Colors.blue, size: Sizes.size14));
                      } else if (state.error.isNotEmpty) {
                        Center(
                          child: Text('Error: ${state.error}'),
                        );
                      } else if (state.completedlist.isEmpty) {
                        const Center(
                          child: Text('No Data'),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Space.y(10),
                          itemCount: state.completedlist.length,
                          itemBuilder: (context, index) {
                            final todo = state.completedlist[index];
                            return ListsTile(todo: todo);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: custombackgroundcolorAccent,
          label: const Text(
            'Add Todo',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          onPressed: () {
            addTodoBottomSheet(context);
          },
        ),
      ),
    );
  }
}
