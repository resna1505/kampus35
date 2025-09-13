import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/absence/absence_bloc.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/home_to_do.dart';
import 'package:kampus/ui/widgets/no_data.dart';
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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

                          if (permissionStatus == PermissionStatus.granted) {
                            // Navigasi ke halaman scanner
                            String? cameraScanResult =
                                await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const QRScannerPage(),
                                  ),
                                );

                            if (cameraScanResult != null &&
                                cameraScanResult.isNotEmpty) {
                              Navigator.pushNamed(
                                context,
                                '/confirm-absent',
                                arguments: {
                                  'namamakul': absenceMethod.namamakul,
                                  'idmakul': absenceMethod.idmakul,
                                  'idruangan': cameraScanResult,
                                  'semester': absenceMethod.semester,
                                  'tahun': absenceMethod.tahun,
                                },
                              );
                            } else {
                              showSnackbar(
                                context,
                                'Info',
                                'Hasil scan tidak valid. Silakan coba lagi.',
                                'info',
                              );
                            }
                          }
                        } else {
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

// Widget untuk halaman scanner QR
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              // Kembali dengan hasil scan
              Navigator.of(context).pop(barcode.rawValue);
              break;
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
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
