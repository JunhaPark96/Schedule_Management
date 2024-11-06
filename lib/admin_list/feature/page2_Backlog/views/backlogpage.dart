import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oneline2/admin_list/intro/util/logout_dialog.dart';
import 'package:oneline2/constants/sizes.dart';
import 'package:oneline2/generate_route.dart';

import '../models/backlogmodel.dart';
import '../repos/backlogrepos.dart';
import '../view_models/backlogviewmodel.dart';

class BacklogPage extends StatefulWidget {
  const BacklogPage({super.key});

  @override
  State<BacklogPage> createState() => _BacklogPageState();
}

class _BacklogPageState extends State<BacklogPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<BacklogModel>> backloglists = ApiService.getTodaysBacklog();
    bool _isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Backlog'),
        elevation: 1,
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                print(_isLoading);
                // ApiService.getTodaysBacklog();
                backloglists = Future.delayed(Duration(seconds: 1), () {
                  return ApiService.getTodaysBacklog();
                });

                _isLoading = false;
              });
            },
            child: const Text('Refresh'),
          ),
          IconButton(
            onPressed: () async {
              logoutDialoge(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraint) {
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

        return FutureBuilder(
          future: backloglists,
          builder: (context, snapshot) {
            print(_isLoading);
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Center(
                child: CupertinoActivityIndicator(
                  radius: 25,
                  color: CupertinoColors.activeBlue,
                ),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: Sizes.size10),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, int index) {
                          var backlog = snapshot.data![index];
                          return Backlog(
                              qname: backlog.Qname, backlog: backlog.Backlog);
                          // return null;
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 25,
                color: CupertinoColors.activeBlue,
              ),
            );
          },
        );
      }),
    );
  }
}
