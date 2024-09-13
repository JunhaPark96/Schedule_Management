import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:lottie/lottie.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/auth_bloc.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/auth_event.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/auth_state.dart';
import 'package:oneline2/constants/util/custom_widgets/custom_textfromfiled.dart';
import 'package:oneline2/constants/space.dart';

import 'package:oneline2/generate_route.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController =
        TextEditingController(); //추후 BLOC 로 이관
    final TextEditingController _passwordController =
        TextEditingController(); //추후 BLOC 로 이관

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.width * 1.2,
            width: size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 200, 243, 234),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Hero(
                tag: 'tag',
                child: Container(
                  constraints: BoxConstraints(maxWidth: size.width * 0.8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LottieBuilder.asset(
                              'assets/lottie/login.json',
                              // 'lottie/login.json',
                              // 'lottie/co.json',
                              // 'lottie/desk.json',
                              // 'lottie/mark.json',
                              height: size.width * 0.5,
                            ),
                            Material(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            Space.y(10),
                            CustomTextFormField(
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'ID',
                              controller: _emailController,
                              // prefixIcon: Iconsax.sms,
                              prefixIcon: FontAwesomeIcons.solidMessage,
                            ),
                            CustomTextFormField(
                              keyboardType: TextInputType.text,
                              hintText: 'Password',
                              controller: _passwordController,
                              // prefixIcon: Iconsax.lock,
                              prefixIcon: FontAwesomeIcons.lock,
                            ),
                            Space.y(10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is AuthAuthenticated) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                      ),
                                    );
                                    Navigator.of(context).pushReplacementNamed(
                                        ScreenRoutes.mainNavi);
                                  } else if (state is AuthError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is AuthLoading) {
                                    return CircularProgressIndicator();
                                  }
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        backgroundColor: const Color.fromARGB(
                                            255, 66, 209, 178)),
                                    onPressed: () {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;
                                      context
                                          .read<AuthBloc>()
                                          .add(LoginRequested(email, password));
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
