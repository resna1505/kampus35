import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/buttons.dart';
import 'package:kampus/ui/widgets/forms.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController(text: '');

  Future<void> sendForgotPassword(String email) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/mahasiswa/lupapassword'),
        body: {
          'email': email,
        },
      );

      if (jsonDecode(res.body)['status'] != '200') {
        throw jsonDecode(res.body)['messages'];
      }
      Navigator.pushNamed(
        context,
        '/reset-password',
        arguments: {'email': email},
      );

      showSnackbar(
          context, 'Success', jsonDecode(res.body)['message'], 'success');
    } catch (e) {
      showSnackbar(context, 'Error', 'Email Tidak Valid', 'error');
    }
  }

  bool validate() {
    if (emailController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Forgot\nPassword',
                  style: blackTextStyle.copyWith(
                    fontSize: 28,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Don't Worry! It happens. Please enter the address associated with your account.",
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomFormField(
                  title: 'Email',
                  controller: emailController,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomFilledButton(
                  title: 'Submit',
                  width: double.infinity,
                  onPressed: () async {
                    if (validate()) {
                      if (emailController.text.isNotEmpty) {
                        sendForgotPassword(
                          emailController.text,
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
      ),
    );
  }
}
