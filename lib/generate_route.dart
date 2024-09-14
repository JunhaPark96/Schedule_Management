import 'package:flutter/material.dart';
import 'package:oneline2/admin_list/feature/Page1_Todo/views/todo_screen.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/views/memo_screen.dart';
import 'package:oneline2/admin_list/feature/page10_EOS_Management/views/eosl_list_page.dart';
import 'package:oneline2/admin_list/feature/page3_Group/views/groupscreen.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/views/cdctable.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/views/plutotable.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/views/eos_screen.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/views/calendar_screen.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/views/contact_list_screen.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/repos/contact_repository.dart';

import 'package:oneline2/admin_list/intro/login_screen/login_screen.dart';

import 'package:oneline2/admin_list/intro/splash_screen/splash_screen.dart';
import 'package:oneline2/main_navi.dart';

class ScreenRoutes {
  static const String splash = '/splash';
  static const String mainNavi = '/mainnavi';
  static const String login = '/login';
  static const String signUp = '/Sign-up';
  static const String group = '/group';
  static const String todo = '/todo';
  static const String backlog = '/backlog';
  static const String memo = '/memo';
  static const String pluto = '/pluto';
  static const String eos = '/eos';
  static const String nine = '/nine';
  static const String cdc = '/cdc';
  static const String calendar = '/calendar';
  static const String contact = '/contact';
  static const String eosl = '/eosl';
}

class AppRouteGenerate {
  final ContactRepository contactRepository = ContactRepository();

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        // return MaterialPageRoute(builder: (ctx) => const SplashScreen());
        // return MaterialPageRoute(builder: (ctx) => const MemoScreen());
        // return MaterialPageRoute(builder: (ctx) => const PlutoGridExamplePage());
        // return MaterialPageRoute(builder: (ctx) => const Plutotable());
        // return MaterialPageRoute(builder: (ctx) => const EOSChartScreen());
        // return MaterialPageRoute(builder: (ctx) => const CdcTable());
        return MaterialPageRoute(
            builder: (ctx) => const MainNavigationScreen());

      case ScreenRoutes.login:
        return MaterialPageRoute(builder: (ctx) => const LoginScreen());
      case ScreenRoutes.mainNavi:
        return MaterialPageRoute(
          builder: (ctx) => const MainNavigationScreen(),
        );
      case ScreenRoutes.group:
        return MaterialPageRoute(builder: (ctx) => GroupPage2());
      case ScreenRoutes.cdc:
        return MaterialPageRoute(builder: (ctx) => const CdcTable());
      case ScreenRoutes.todo:
        return MaterialPageRoute(builder: (ctx) => const TodoScreen());
      case ScreenRoutes.memo:
        return MaterialPageRoute(builder: (ctx) => const MemoScreen());
      case ScreenRoutes.pluto:
        return MaterialPageRoute(builder: (ctx) => const Plutotable());
      case ScreenRoutes.eos:
        return MaterialPageRoute(builder: (ctx) => const EOSChartScreen());
      case ScreenRoutes.calendar:
        return MaterialPageRoute(builder: (ctx) => const CalendarScreen());
      case ScreenRoutes.contact:
        // Pass contactRepository to ContactListScreen
        return MaterialPageRoute(
          builder: (ctx) =>
              ContactListScreen(contactRepository: contactRepository),
        );
      case ScreenRoutes.eosl:
        return MaterialPageRoute(builder: (ctx) => const EoslListPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (ctx) {
      return const Scaffold(
        body: Center(
          child: Text('Something Error'),
        ),
      );
    });
  }
}
