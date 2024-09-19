import 'package:flutter/material.dart';

class BacklogDetailPage extends StatelessWidget {
  final String qname, backlog;

  const BacklogDetailPage({
    super.key,
    required this.qname,
    required this.backlog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          qname,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Hero(
        tag: qname,
        child: Center(
          child: Text(
            backlog,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
