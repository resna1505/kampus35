import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/buttons.dart';
import 'package:kampus/ui/widgets/forms.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final otpController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  Future<void> sendVerifikasiOtp(
      String otp, String password, String email) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/mahasiswa/verifikasiotp'),
        body: {
          'email': email,
          'otp': otp,
          'new_password': password,
        },
      );

      if (jsonDecode(res.body)['status'] != '200') {
        throw jsonDecode(res.body)['messages'];
      }
      Navigator.pushNamed(context, '/login-page');

      showSnackbar(
          context, 'Success', jsonDecode(res.body)['message'], 'success');
    } catch (e) {
      showSnackbar(context, 'Error', 'Email Tidak Valid', 'error');
    }
  }

  bool validate() {
    if (otpController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? email = arguments?['email'];

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          '',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Reset\nPassword',
                  style: blackTextStyle.copyWith(
                    fontSize: 28,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomFormField(
                  title: 'OTP',
                  controller: otpController,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomFormField(
                  title: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomFilledButton(
                  title: 'Submit',
                  width: double.infinity,
                  onPressed: () async {
                    if (validate()) {
                      if (otpController.text.isNotEmpty ||
                          passwordController.text.isNotEmpty) {
                        sendVerifikasiOtp(
                          otpController.text,
                          passwordController.text,
                          email.toString(),
                        );
                      } else {
                        showSnackbar(
                            context, 'Error', 'Data tidak lengkap', 'error');
                      }
                    } else {
                      showSnackbar(
                          context, 'Error', 'Email harus di isi', 'error');
                    }
                  },
                )
              ],
            ),
          )
        ],
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 24,
        // ),
        // children: const [
        //   SizedBox(
        //     height: 12,
        //   ),
        //   Column(
        //     children: [
        //       Text(
        //         'data',
        //         style: blackTextStyle.copyWith(
        //           fontSize: 16,
        //         ),
        //       ),
        //     ],
        //   )
        // ],
      ),
    );
  }
}
