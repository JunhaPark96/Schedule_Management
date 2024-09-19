import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_bloc.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_event.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_state.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/widgets/add_memo_bottomsheet.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/widgets/lists_tile.dart';
import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import 'package:oneline2/constants/colors.dart';
import 'package:oneline2/constants/gaps.dart';
import 'package:oneline2/constants/sizes.dart';

import 'package:oneline2/constants/space.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  final TextEditingController searchController = TextEditingController();
  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo List'),
        elevation: 1,
        actions: [
          Gaps.h10,
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
                context.read<MemoBloc>().add(FilterMemo(query));
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
      body: Column(
        children: [
          Gaps.v10,
          Expanded(
            child: BlocConsumer<MemoBloc, MemoState>(
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
                } else if (state.memolist.isEmpty) {
                  const Center(
                    child: Text('No Data'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                    // scrollDirection: Axis.horizontal,
                    itemCount: state.filterlist.length,
                    separatorBuilder: (context, index) => Space.y(20),
                    itemBuilder: (context, index) {
                      final memo = state.filterlist[index];
                      return ListsTile(memo: memo);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: custombackgroundcolorAccent,
        label: const Text(
          'Add Memo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          addMemoBottomSheet(context);
        },
      ),
    );
  }
}
