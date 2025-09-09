import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/auth/auth_bloc.dart';
import 'package:kampus/shared/theme.dart';

class BuildProfile extends StatelessWidget {
  const BuildProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 10,
              top: 10,
              bottom: 16,
            ),
            color: lightBackgroundColor,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user.name.toString(),
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      'Mahasiswa | ${state.user.jurusan.toString()}',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                // Row(
                //   children: [
                //     Container(
                //       width: 24,
                //       height: 24,
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.rectangle,
                //         image: DecorationImage(
                //           image: AssetImage(
                //             'assets/img_profile.png',
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 16,
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.pushNamed(context, '/notification-mahasiswa');
                //       },
                //       child: Container(
                //         width: 24,
                //         height: 24,
                //         decoration: BoxDecoration(
                //           shape: BoxShape.rectangle,
                //           color: purpleColor,
                //           borderRadius: BorderRadius.circular(4.0),
                //         ),
                //         child: Icon(
                //           Icons.notifications_none,
                //           color: whiteColor,
                //           size: 18,
                //         ),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 16,
                //     ),
                //     Container(
                //       width: 24,
                //       height: 24,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.rectangle,
                //         color: greenColor,
                //         borderRadius: BorderRadius.circular(4.0),
                //       ),
                //       child: Icon(
                //         Icons.qr_code_scanner,
                //         color: whiteColor,
                //         size: 18,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   width: 16,
                // ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
