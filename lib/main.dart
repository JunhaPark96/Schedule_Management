import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; // provider 패키지 필요
import 'package:oneline2/admin_list/feature/Page1_Todo/repos/todo_repos.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_bloc.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/view_models/todo_event.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/views/todo_screen.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_bloc.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/view_models/memo_event.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/views/memo_screen.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/view_models/cdc_bloc.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/view_models/cdc_event.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/views/cdctable.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/view_models/license_bloc.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/view_models/license_event.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/views/plutotable.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/view_models/eos_bloc.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/view_models/eos_event.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/views/eos_screen.dart';

import 'package:oneline2/admin_list/feature/page8_Calendar/view_models/calendar_bloc.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/repos/calendar_repos.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_bloc.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/view_models/eosl_event.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/auth_bloc.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/login_api.dart';
import 'package:oneline2/admin_list/intro/login_screen/login_screen.dart';

import 'package:oneline2/admin_list/intro/splash_screen/splash_screen_cubit.dart';
import 'package:oneline2/constants/colors.dart';

import 'package:oneline2/constants/util/service_locatior/di/configure_injection.dart';
import 'package:oneline2/generate_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SplashScreenCubit>()),
        BlocProvider(create: (context) => AuthBloc(LoginApi())),
        BlocProvider(create: (context) => TodoBloc()..add(FetchTodos())),
        BlocProvider(create: (context) => MemoBloc()..add(FetchMemo())),
        BlocProvider(create: (context) => EOSBloc()..add(FetchEOS())),
        BlocProvider(create: (context) => LicenseBloc()..add(FetchLicense())),
        BlocProvider(create: (context) => CdcBloc()..add(FetchCdc())),
        BlocProvider(
            create: (context) => EventBloc(getIt<CalendarRepository>())),
        BlocProvider(
            create: (context) => EoslBloc()..add(FetchEoslList())), // 박준하 bloc
      ],
      child: MyApp(
        appRouteGenerate: AppRouteGenerate(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouteGenerate appRouteGenerate;
  const MyApp({super.key, required this.appRouteGenerate});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouteGenerate.onGenerateRoute,
      title: "One Line",
      theme: ThemeData(
        fontFamily: 'OpenSans',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
