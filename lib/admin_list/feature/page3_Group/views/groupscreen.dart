import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import 'package:oneline2/constants/colors.dart';
import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';

import '../models/groupmodel.dart';
import '../repos/grouprepos.dart';
import '../view_models/groupviewmodel.dart';

import 'package:get/get.dart';

class GroupPage2 extends StatefulWidget {
  GroupPage2({super.key});

  @override
  State<GroupPage2> createState() => _GroupPage2State();
}

class _GroupPage2State extends State<GroupPage2> {
  final TextEditingController searchController = TextEditingController();
  bool _folded = true;
  final GroupViewModelController groupViewModelController = Get.put(
      GroupViewModelController(
          ApiService(Uri.parse("http://172.26.202.100:8090/get_group_call"))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Memo List'),
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
                groupViewModelController.filterGroups(query);
              },
            ),
          ),
          Gaps.h10,
          ElevatedButton(
              onPressed: () => groupViewModelController.fetchData(),
              child: const Text('Refresh')),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () => groupViewModelController.InsertData(),
              child: const Text('Insert New Row')),
          IconButton(
            onPressed: () async {
              logoutDialoge(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Obx(
          () {
            if (groupViewModelController.isLoading.value) {
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 25,
                  color: CupertinoColors.activeBlue,
                ),
              );
            } else if (groupViewModelController.errorMessage.isNotEmpty) {
              return Center(
                child: Text(groupViewModelController.errorMessage.value),
              );
            } else {
              return const GroupBuilder();
            }
          },
        ),
      ),
    );
  }
}

class GroupBuilder extends StatefulWidget {
  const GroupBuilder({super.key});

  @override
  State<GroupBuilder> createState() => _GroupBuilderState();
}

class _GroupBuilderState extends State<GroupBuilder> {
  final GroupViewModelController groupViewModelController = Get.find();

  final TextEditingController searchController = TextEditingController();

  bool _folded = true;

  List<String> filteredItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gaps.v10,
        // AnimatedContainer(
        //   duration: const Duration(milliseconds: 200),
        //   width: _folded ? 150 : 250,
        //   // height: 42,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(32),
        //     color: Colors.white,
        //     boxShadow: kElevationToShadow[6],
        //   ),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: TextField(
        //             controller: searchController,
        //             decoration: InputDecoration(
        //               hintText: 'Search',
        //               prefixIcon: Column(
        //                 children: [
        //                   Gaps.v10,
        //                   Material(
        //                     type: MaterialType.transparency,
        //                     child: InkWell(
        //                       borderRadius: BorderRadius.only(
        //                         topLeft: Radius.circular(_folded ? 24 : 0),
        //                         topRight: const Radius.circular(24),
        //                         bottomLeft: Radius.circular(_folded ? 24 : 0),
        //                         bottomRight: const Radius.circular(24),
        //                       ),
        //                       child: Icon(_folded ? Icons.search : Icons.close),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               prefixIconColor: Colors.teal.shade200,
        //               border: InputBorder.none,
        //             ),
        //             onTap: () {
        //               setState(() {
        //                 _folded = !_folded;
        //               });
        //             },
        //             onChanged: (group) {
        //               groupViewModelController.filterGroups(group);
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraint) {
            int crossAxisCount;
            double screenWidth = constraint.maxWidth;

            if (screenWidth > 1800) {
              crossAxisCount = 6;
            } else if (screenWidth > 1500) {
              crossAxisCount = 5;
            } else if (screenWidth > 1300) {
              crossAxisCount = 4;
            } else if (screenWidth > 1000) {
              crossAxisCount = 3;
            } else if (screenWidth > 800) {
              crossAxisCount = 2;
            } else if (screenWidth > 500) {
              crossAxisCount = 1;
            } else {
              crossAxisCount = 1;
            }

            return Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: groupViewModelController.filteredGroups.length,
                  itemBuilder: (context, index) {
                    final group =
                        groupViewModelController.filteredGroups[index];

                    return AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.grey.shade100,
                          elevation: 4,
                          // margin:                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Gaps.h10,
                                  Icon(
                                    Icons.data_usage,
                                    color: Colors.teal.shade200,
                                    size: 40,
                                  ),
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.grey.shade400,
                                thickness: 1,
                                indent: Sizes.size14,
                                endIndent: Sizes.size14,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            Sizes.size4,
                                          )),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            group.L3!,
                                            style: const TextStyle(
                                                fontSize: Sizes.size14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("담당자: ${group.adminUser}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    Text("리더:  ${group.adminLeader}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    Text("설명:  ${group.description}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                  ],
                                ),
                              ),
                              Gaps.h14,
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                    onPressed: () {
                                      _editGroup(context, group);
                                    },
                                  ),
                                  IconButton(
                                    icon:
                                        const FaIcon(FontAwesomeIcons.trashCan),
                                    onPressed: () {
                                      final updatedGroup = L3GroupModel(
                                        group_seq: group.group_seq,
                                      );
                                      groupViewModelController.DeleteData(
                                          updatedGroup);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _editGroup(BuildContext context, L3GroupModel group) {
    final TextEditingController L3controller =
        TextEditingController(text: group.L3);
    final TextEditingController adminUsercontroller =
        TextEditingController(text: group.adminUser);
    final TextEditingController adminLeadercontroller =
        TextEditingController(text: group.adminLeader);
    final TextEditingController descriptioncontroller =
        TextEditingController(text: group.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit ${group.L3}"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: L3controller,
                decoration: InputDecoration(labelText: 'L3'),
              ),
              TextField(
                controller: adminUsercontroller,
                decoration: InputDecoration(labelText: 'adminUser'),
              ),
              TextField(
                controller: adminLeadercontroller,
                decoration: InputDecoration(labelText: 'adminLeader'),
              ),
              TextField(
                controller: descriptioncontroller,
                decoration: InputDecoration(labelText: 'description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedGroup = L3GroupModel(
                  group_seq: group.group_seq,
                  L3: L3controller.text,
                  adminUser: adminUsercontroller.text,
                  adminLeader: adminLeadercontroller.text,
                  description: descriptioncontroller.text,
                );
                groupViewModelController
                    .updateData(updatedGroup)
                    .then((value) => Navigator.of(context).pop());
              },
              child: Text('Save'),
            )
          ],
        );
      }, // builder
    ); // showDialog
  }
}
