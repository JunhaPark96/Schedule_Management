import 'package:flutter/material.dart';
import 'package:oneline/router.dart';
import 'package:provider/provider.dart';
import 'package:oneline/models/event_provider.dart';
import 'package:oneline/models/contact_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                ContactProvider()), // 20240716_김재영 : ContactProvider 추가
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
