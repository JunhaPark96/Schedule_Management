import 'package:flutter/material.dart';
import 'package:oneline2/constants/sizes.dart';

import '../views/backlogdetailpage.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';

class Backlog extends StatefulWidget {
  final String qname, backlog;

  const Backlog({
    super.key,
    required this.qname,
    required this.backlog,
  });

  @override
  State<Backlog> createState() => _BacklogState();
}

class _BacklogState extends State<Backlog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BacklogDetailPage(qname: widget.qname, backlog: widget.backlog),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: widget.qname,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              height: 110,
              width: 150,
              child: Column(
                children: [
                  const FaIcon(
                    // CupertinoIcons.personalhotspot,
                    // CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
                    CupertinoIcons.square_stack_3d_down_right_fill,
                    size: Sizes.size52,
                  ),
                  Text(
                    widget.qname,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Text(
                    'Backlog: ' + widget.backlog,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            widget.backlog == '0' ? Colors.black : Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
