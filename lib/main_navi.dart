import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:oneline2/admin_list/feature/Page1_Todo/views/todo_screen.dart';
import 'package:oneline2/admin_list/feature/Page5_Memo/views/memo_screen.dart';
import 'package:oneline2/admin_list/feature/page2_Backlog/views/backlogpage.dart';

import 'package:oneline2/admin_list/feature/page3_Group/views/groupscreen.dart';
import 'package:oneline2/admin_list/feature/page4_CDC/views/cdctablescreen.dart';
import 'package:oneline2/admin_list/feature/page4_CDC_table/views/cdctable.dart';
import 'package:oneline2/admin_list/feature/page6_Pluto_Table/views/plutotable.dart';
import 'package:oneline2/admin_list/feature/page7_EOS/views/eos_screen.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/views/calendar_screen.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/views/contact_list_screen.dart';
import 'package:oneline2/admin_list/feature/page99_TEST/views/test.dart';
import 'package:oneline2/admin_list/intro/splash_screen/splash_screen.dart';
import 'package:oneline2/constants/colors.dart';
import 'package:oneline2/constants/sizes.dart';
import 'package:oneline2/admin_list/feature/page9_Contact/repos/contact_repository.dart'; // Import the ContactRepository

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final ContactRepository contactRepository =
      ContactRepository(); // Create instance of ContactRepository

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customprimarycolor,
      body: Row(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: IntrinsicHeight(
                child: NavigationRail(
                    minWidth: 60,
                    elevation: 10,
                    useIndicator: true,
                    indicatorColor: Colors.teal.shade100,
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.noteSticky),
                        label: Text('Todo List'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.computer),
                        label: Text('Backlog'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.peopleGroup),
                        label: Text('Find Group'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.table),
                        label: Text('CDC Table List'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.greaterThan),
                        label: Text('Memo List'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.chartSimple),
                        label: Text('License'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.timeline),
                        label: Text('EOS'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.bug),
                        label: Text('test'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.bug),
                        label: Text('test'),
                      ),
                      NavigationRailDestination(
                        icon: FaIcon(FontAwesomeIcons.addressBook),
                        label: Text('Contact'),
                      ),
                    ],
                    selectedIndex: _selectedIndex),
              ),
            ),
          ),
          const VerticalDivider(thickness: 2, width: 1),
          Expanded(
            child: _buildSelectedScreen(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const TodoScreen();
      case 1:
        return const BacklogPage();
      case 2:
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: GroupPage2(),
        );
      case 3:
        return const CdcTable();
      case 4:
        return const MemoScreen();
      case 5:
        return const Plutotable();
      case 6:
        return const EOSChartScreen();
      case 7:
        return const MyWidget();
      case 8:
        return const CalendarScreen();
      case 9:
        // Pass contactRepository to ContactListScreen
        return ContactListScreen(contactRepository: contactRepository);

      default:
        return const SplashScreen();
    }
  }
}
