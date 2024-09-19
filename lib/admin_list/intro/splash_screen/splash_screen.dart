import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oneline2/generate_route.dart';

class SplashScreen extends StatelessWidget {
  static const routeURL = ScreenRoutes.splash;
  static const routeName = 'splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        Navigator.of(context).pushReplacementNamed(ScreenRoutes.login);
      },
    );

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) async {
    //     String nextRoute =
    //         await context.read<SplashScreenCubit>().nextScreenRoute();
    //   },
    // );

    return const Scaffold(
      body: Center(
        child: IconSection(),
      ),
    );
  }
}

class IconSection extends StatefulWidget {
  const IconSection({super.key});

  @override
  State<IconSection> createState() => _IconSectionState();
}

class _IconSectionState extends State<IconSection> {
  bool changeSize = false;
  @override
  void initState() {
    Timer(const Duration(microseconds: 1500), () {
      setState(() {
        changeSize = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.bounceOut,
      height: changeSize ? 250 : 50,
      width: changeSize ? 250 : 50,
      decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage('assets/image/app-icon.png'))),
      duration: const Duration(milliseconds: 1500),
    );
  }
}
