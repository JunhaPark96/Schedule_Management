import 'package:go_router/go_router.dart';
import 'package:oneline/models/contact_model.dart';
import 'package:oneline/screens/calendar_screen.dart';
import 'package:oneline/screens/add_event_page.dart';
import 'package:oneline/screens/server_list.dart';
import 'package:oneline/screens/todo_page.dart';
import 'package:oneline/screens/schedule_page.dart';
import 'package:oneline/main_navi.dart';
import 'package:oneline/screens/contact_list_screen.dart';
import 'package:oneline/screens/contact_detail_page.dart';

final router = GoRouter(
  initialLocation: "/mainnavi",
  routes: [
    GoRoute(
      path: MainNavigationScreen.routeURL,
      name: MainNavigationScreen.routeName,
      builder: (context, state) => const MainNavigationScreen(),
      routes: [
        GoRoute(
          path: 'calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: 'add-event',
          builder: (context, state) => const AddEventPage(),
        ),
        GoRoute(
          path: 'todo',
          builder: (context, state) => const TodoPage(),
        ),
        GoRoute(
          path: 'schedule',
          builder: (context, state) => const SchedulePage(),
        ),
        GoRoute(
          path: 'contact',
          builder: (context, state) => ContactListScreen(),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final contact = state.extra as Contact;
                return ContactDetailPage(contact: contact);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'server_list', // 서버 리스트 경로 추가
          builder: (context, state) => const ServerList(),
        ),
      ],
    ),
  ],
);
