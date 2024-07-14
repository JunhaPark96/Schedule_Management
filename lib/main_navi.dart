import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oneline/models/tab_model.dart';
import 'package:oneline/screens/calendar_screen.dart';
import 'package:oneline/screens/server_list.dart';
import 'package:oneline/widgets/side_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:oneline/screens/contact_list_screen.dart'; // 추가

class MainNavigationScreen extends StatefulWidget {
  static const routeURL = "/mainnavi";
  static const routeName = "mainnavi";
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _animation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_animationController);

  late final Animation<Offset> _panelAnimation = Tween(
    begin: const Offset(0, -5),
    end: Offset.zero,
  ).animate(_animationController);

  void _onTitleTap() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _onSideNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/mainnavi/calendar');
        break;
      case 1: // 서버 리스트
        context.go('/mainnavi/server_list');
        break;
      case 3: // 연락처
        context.go('/mainnavi/contact');
        break;
      default:
        context.go('/mainnavi');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouterState goRouterState = GoRouterState.of(context);
    final String location = goRouterState.location;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Main Navigation'),
              const SizedBox(width: 3),
              RotationTransition(
                turns: _animation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          SideNavigationBar(
            selectedIndex: _selectedIndex,
            onTap: _onSideNavTap,
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: Stack(
              children: [
                if (location.contains('/mainnavi/calendar'))
                  const CalendarScreen(),
                if (location.contains('/mainnavi/contact')) ContactListScreen(),
                if (location.contains('/mainnavi/server_list'))
                  const ServerList(),
                if (!location.contains('/mainnavi/calendar') &&
                    !location.contains('/mainnavi/contact') &&
                    !location.contains('/mainnavi/server_list'))
                  Container(
                    child: const Text('Main Screen'),
                  ),
                // Offstage(
                //   offstage: _selectedIndex != 1,
                //   child: Container(
                //     child: const Text('Server List Screen'),
                //   ),
                // ),
                Offstage(
                  offstage: _selectedIndex != 2,
                  child: Container(
                    child: const Text('Work Schedule Screen'),
                  ),
                ),
                SlideTransition(
                  position: _panelAnimation,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: tabs.asMap().entries.map((entry) {
                        int idx = entry.key;
                        TabModel tab = entry.value;
                        return ListTile(
                          title: Row(
                            children: [
                              FaIcon(
                                tab.icon,
                                color: Colors.black,
                                size: 16,
                              ),
                              const SizedBox(width: 20),
                              Text(tab.title),
                            ],
                          ),
                          onTap: () => _onSideNavTap(idx),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
