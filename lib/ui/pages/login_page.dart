import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kampus/blocs/auth/auth_bloc.dart';
import 'package:kampus/models/sign_in_form_model.dart';
import 'package:kampus/services/auth_provider.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/buttons.dart';
import 'package:kampus/ui/widgets/forms.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:show_hide_password/show_hide_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'assets/img_login.png',
    'assets/img_login2.png',
    'assets/img_login3.png',
  ];

  List<String> pageTexts = [
    'Online education in\nyour hand',
    'Learn from anywhere\nat anytime',
    'Empower your future\nwith knowledge'
  ];

  bool validate() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    }
    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    final auhtProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            // showCustomSnackbar(context, state.e);
            showSnackbar(context, 'Error', state.e, 'error');
          }

          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home-page-mahasiswa', (route) => false);
            AnimatedSnackBar.rectangle(
              'Success',
              'Selamat datang, login sukses!',
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
            ).show(
              context,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              SizedBox(
                height: 290,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 200),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              pageTexts[_currentPage],
                              style: blackTextStyle.copyWith(
                                fontSize: 21,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_images.length, (index) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index ? blueDarkColor : blueSoftColor,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              // Container(
              //   height: 350,
              //   padding: const EdgeInsets.only(right: 24),
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage(
              //         'assets/img_login.png',
              //       ),
              //     ),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       const SizedBox(
              //         height: 228,
              //       ),
              //       Text(
              //         'Online education in\nyour hand',
              //         style: blackTextStyle.copyWith(
              //           fontSize: 21,
              //         ),
              //         textAlign: TextAlign.right,
              //       ),
              //       const SizedBox(
              //         height: 40,
              //       ),
              //       Row(
              //         children: [
              //           Container(
              //             width: 12,
              //             height: 12,
              //             margin: const EdgeInsets.only(
              //               right: 10,
              //               left: 155,
              //             ),
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: blueDarkColor,
              //             ),
              //           ),
              //           Container(
              //             width: 12,
              //             height: 12,
              //             margin: const EdgeInsets.only(
              //               right: 10,
              //             ),
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: blueSoftColor,
              //             ),
              //           ),
              //           Container(
              //             width: 12,
              //             height: 12,
              //             margin: const EdgeInsets.only(
              //               right: 10,
              //             ),
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: blueSoftColor,
              //             ),
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: whiteColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi!,',
                              style: blackTextStyle.copyWith(
                                fontSize: 21,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome ',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 21,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.waving_hand,
                                  color: Colors.yellow.shade500,
                                  size: 23,
                                ),
                              ],
                            ),
                            Text(
                              'Student Apps | Batam University',
                              style: greyTextStyle.copyWith(
                                fontWeight: semiBold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Note : Email Input
                    CustomFormField(
                      title: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Note : Password Input
                    ShowHidePassword(
                      hidePassword: true,
                      passwordField: (hidePassword) {
                        return TextField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: hidePassword,
                          showCursor: false,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Enter the password',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: "",
                          ),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                        );
                      },
                      iconSize: 18,
                      visibleOffIcon: Iconsax.eye_slash,
                      visibleOnIcon: Iconsax.eye,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/forgot-password');
                              },
                              child: Text(
                                'Forgot Password',
                                style: redTextStyle.copyWith(
                                  fontWeight: semiBold,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomFilledButton(
                      title: 'Log In',
                      width: 300,
                      onPressed: () async {
                        String deviceId = await getDeviceId();
                        if (validate()) {
                          context.read<AuthBloc>().add(
                                AuthLogin(
                                  SignInFormModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    consoleId: deviceId,
                                  ),
                                ),
                              );
                          auhtProvider.signIn(
                            emailController.text,
                            passwordController.text,
                          );
                        } else {
                          // showCustomSnackbar(
                          //     context, 'Semua Field harus di isi');
                          showSnackbar(context, 'Error',
                              'Semua Field harus di isi', 'error');
                        }
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, '/home-page-mahasiswa', (route) => false);
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
