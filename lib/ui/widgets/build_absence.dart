import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/absence/absence_bloc.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/home_to_do.dart';
import 'package:kampus/ui/widgets/no_data.dart';
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shimmer/shimmer.dart';

class BuildAbsence extends StatefulWidget {
  const BuildAbsence({super.key});

  @override
  State<BuildAbsence> createState() => _BuildAbsenceState();
}

class _BuildAbsenceState extends State<BuildAbsence> {
  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(color: whiteColor),
      child: BlocProvider(
        create: (context) => AbsenceBloc()..add(AbsenceGet()),
        child: BlocBuilder<AbsenceBloc, AbsenceState>(
          builder: (context, state) {
            if (state is AbsenceLoading) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Skeleton(height: 12, width: 30),
                          SizedBox(width: 4),
                          Skeleton(height: 12, width: 140),
                        ],
                      ),
                      SizedBox(height: 8),
                      Skeleton(height: 12, width: 200),
                      SizedBox(height: 8),
                      Skeleton(height: 115, width: double.infinity),
                      SizedBox(height: 8),
                      Skeleton(height: 115, width: double.infinity),
                      SizedBox(height: 8),
                      Skeleton(height: 115, width: double.infinity),
                      SizedBox(height: 8),
                      Skeleton(height: 115, width: double.infinity),
                      SizedBox(height: 8),
                      Skeleton(height: 115, width: double.infinity),
                    ],
                  ),
                ),
              );
            } else if (state is AbsenceSuccess) {
              return Column(
                children: [
                  Header(jumlah: state.absence.length),
                  const SizedBox(height: 12),
                  ...state.absence.map((absenceMethod) {
                    return HomeToDo(
                      absenceMethod: absenceMethod,
                      onTap: () async {
                        if (absenceMethod.statusabsen == 0) {
                          var permissionStatus = await Permission.camera.status;
                          if (permissionStatus.isDenied) {
                            permissionStatus = await Permission.camera
                                .request();
                          }
                          // if (permissionStatus == PermissionStatus.granted) {
                          //   String? cameraScanResult = await scanner.scan();

                          //   if (cameraScanResult != null &&
                          //       cameraScanResult.isNotEmpty) {
                          //     Navigator.pushNamed(
                          //       context,
                          //       '/confirm-absent',
                          //       arguments: {
                          //         'namamakul': absenceMethod.namamakul,
                          //         'idmakul': absenceMethod.idmakul,
                          //         'idruangan': cameraScanResult,
                          //         'semester': absenceMethod.semester,
                          //         'tahun': absenceMethod.tahun,
                          //       },
                          //     );
                          //   } else {
                          //     // showCustomSnackbar(
                          //     //   context,
                          //     //   'Hasil scan tidak valid. Silakan coba lagi.',
                          //     // );
                          //     showSnackbar(
                          //       context,
                          //       'Info',
                          //       'Hasil scan tidak valid. Silakan coba lagi.',
                          //       'info',
                          //     );
                          //   }
                          // }
                        } else {
                          // showCustomSnackbar(
                          //   context,
                          //   'Anda sudah absen',
                          // );
                          showSnackbar(
                            context,
                            'Info',
                            'Anda sudah absen',
                            'info',
                          );
                        }
                      },
                    );
                  }).toList(),
                ],
              );
              // children: [
              //   const Header(jumlah: 1),
              //   const SizedBox(
              //     height: 12,
              //   ),
              //   HomeToDo(
              //     title: 'Metodologi Penelitian Epidemiologi',
              //     status: 'Completed',
              //     date: '2024-10-13 09:00',
              //     onTap: () async {
              //       if ('Completed' == 'Completed') {
              //         showCustomSnackbar(
              //           context,
              //           'Absent sudah di isi',
              //         );
              //       } else {
              //         var permissionStatus = await Permission.camera.status;
              //         if (permissionStatus.isDenied) {
              //           permissionStatus = await Permission.camera.request();
              //         }
              //         if (permissionStatus == PermissionStatus.granted) {
              //           String? cameraScanResult = await scanner.scan();
              //           if (cameraScanResult != null) {
              //             setState(() {});
              //           }
              //           Navigator.pushNamed(
              //             context,
              //             '/confirm-absent',
              //             arguments: {'scanResult': cameraScanResult},
              //           );
              //         }
              //       }
              //     },
              //   ),
              //   // HomeToDo(
              //   //   title: 'Dasar Diagnotik Terapi',
              //   //   status: 'Incomplete',
              //   //   date: '2024-10-13 09:00',
              //   //   onTap: () async {
              //   //     if ('Completed' == 'Incomplete') {
              //   //       showCustomSnackbar(
              //   //         context,
              //   //         'Absent sudah di isi',
              //   //       );
              //   //     } else {
              //   //       var permissionStatus = await Permission.camera.status;
              //   //       if (permissionStatus.isDenied) {
              //   //         permissionStatus = await Permission.camera.request();
              //   //       }

              //   //       if (permissionStatus == PermissionStatus.granted) {
              //   //         String? cameraScanResult = await scanner.scan();
              //   //         if (cameraScanResult != null) {
              //   //           setState(() {});
              //   //         }
              //   //         Navigator.pushNamed(context, '/confirm-absent');
              //   //       }
              //   //     }
              //   //   },
              //   // ),
              // ],
            } else {
              return const Column(
                children: [
                  Header(jumlah: 0),
                  SizedBox(height: 12),
                  NoData(title: 'jadwal absen'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final int jumlah;

  const Header({super.key, required this.jumlah});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: redColor,
                  ),
                  child: Center(
                    child: Text(
                      jumlah.toString(),
                      style: whiteTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: medium,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Absen Anda Hari ini',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'This is your personal absence list',
              style: greyTextStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
