import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/buttons.dart';
import 'package:kampus/ui/widgets/forms.dart';

class ManageProfile extends StatelessWidget {
  const ManageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          'Manage Profile',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          const SizedBox(
            height: 10,
          ),
          const CustomFormField(
            title: 'Email',
          ),
          const CustomFormField(
            title: 'Jenis Kelamin',
          ),
          const CustomFormField(
            title: 'Password',
            obscureText: true,
          ),
          const SizedBox(
            height: 30,
          ),
          CustomFilledButton(
            title: 'Ubah Profil',
            width: 300,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home-page-mahasiswa', (route) => false);
            },
          )
        ],
      ),
    );
  }
}
