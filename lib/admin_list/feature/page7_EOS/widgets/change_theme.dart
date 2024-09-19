import 'global_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ChangeThemeSuccess extends ThemeState {
  final bool isDarkMode;
  ChangeThemeSuccess(this.isDarkMode);
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  void changeTheme(isDarkMode) {
    emit(ChangeThemeSuccess(isDarkMode));
  }
}

class ChangeThemePage extends StatefulWidget {
  const ChangeThemePage({super.key});

  @override
  State<ChangeThemePage> createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  late ThemeCubit _themeCubit;

  @override
  void initState() {
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _globalWidget.globalAppBar(),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Light Theme'),
              Text('Dark Theme'),
            ],
          ),
        ));
  }
}
