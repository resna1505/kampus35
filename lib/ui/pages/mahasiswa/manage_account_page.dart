import 'package:flutter/material.dart';
import 'package:kampus/blocs/auth/auth_bloc.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/buttons.dart';
import 'package:kampus/ui/widgets/forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({super.key});

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  final passwordCurrentController = TextEditingController(text: '');
  final passwordNewController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          'Manage Account',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            // showCustomSnackbar(context, state.e);
            showSnackbar(context, 'Error', state.e, 'error');
          }

          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login-page', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            children: [
              const SizedBox(
                height: 10,
              ),
              CustomFormField(
                title: 'Kata Sandi Lama',
                obscureText: true,
                controller: passwordCurrentController,
              ),
              CustomFormField(
                title: 'Kata Sandi Baru',
                obscureText: true,
                controller: passwordNewController,
              ),
              // const CustomFormField(
              //   title: 'Masukkan Lagi Password Baru',
              //   obscureText: true,
              // ),
              const SizedBox(
                height: 30,
              ),
              CustomFilledButton(
                title: 'Simpan',
                width: 300,
                onPressed: () {
                  context.read<AuthBloc>().add(
                        AuthUpadatePassword(
                          passwordCurrentController.text,
                          passwordNewController.text,
                        ),
                      );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
