import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/auth/auth_bloc.dart';
import 'package:kampus/shared/theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home-page-mahasiswa', (route) => false);
            });
          }

          if (state is AuthFailed) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login-page', (route) => false);
            });
          }
        },
        child: Center(
          child: Container(
            // width: 155,
            height: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/logo_uniba.png',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
