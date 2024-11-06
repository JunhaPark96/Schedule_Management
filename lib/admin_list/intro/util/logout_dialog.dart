import 'package:flutter/material.dart';
import 'package:oneline2/generate_route.dart';

Future<dynamic> logoutDialoge(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure?'),
      content: RichText(
          text: const TextSpan(
              text: "If you want to logout click ",
              style: TextStyle(color: Colors.black),
              children: [
            TextSpan(
                text: " Confirm ",
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Colors.black)),
            TextSpan(text: 'else click'),
            TextSpan(
                text: ' Cancel ',
                style:
                    TextStyle(fontWeight: FontWeight.w800, color: Colors.black))
          ])),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () async {
              // await context.read<SignInBloc>().logout();
              Future.delayed(
                const Duration(microseconds: 500),
                () {
                  Navigator.of(context)
                      .pushReplacementNamed(ScreenRoutes.login);
                },
              );
            },
            child: const Text('Confirm'))
      ],
    ),
  );
}
