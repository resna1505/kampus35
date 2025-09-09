// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/buttons.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ConfirmAbsentPage extends StatefulWidget {
  const ConfirmAbsentPage({super.key});

  @override
  State<ConfirmAbsentPage> createState() => _ConfirmAbsentPageState();
}

class _ConfirmAbsentPageState extends State<ConfirmAbsentPage> {
  Future<void> sendAbsenceData(
      String idMakul, String idRuangan, String semester, String tahun) async {
    try {
      final idMahasiswa = await AuthService().getIdMahasiswa();
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = '';

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
      }

      final res = await http.post(
        Uri.parse('$baseUrl/mahasiswa/postabsen'),
        body: {
          'id': idMahasiswa,
          'idmakul': idMakul,
          'idruangan': idRuangan,
          'tahunajaran': tahun,
          'semester': semester,
          'consoleId': deviceId,
        },
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['messages'];
      }
      Navigator.pushNamedAndRemoveUntil(
          context, '/home-page-mahasiswa', (route) => false);
      // successSnackbar(context, 'data berhasil disimpan');
      showSnackbar(context, 'Success', 'data berhasil disimpan', 'success');
    } catch (e) {
      // showCustomSnackbar(context, e.toString());
      showSnackbar(context, 'Error', e.toString(), 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? namamakul = arguments?['namamakul'];
    final String? idMakul = arguments?['idmakul'];
    final String? idRuangan = arguments?['idruangan'];
    final String? semester = arguments?['semester'];
    final String? tahun = arguments?['tahun'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
          'Confirm Absent',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$namamakul',
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  '$idMakul',
                  style: greyDarkTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                ),
                const SizedBox(height: 12),
                CustomFilledButton(
                  title: 'Confirm',
                  width: double.infinity,
                  onPressed: () {
                    if (idMakul != null && idRuangan != null) {
                      sendAbsenceData(
                        idMakul,
                        idRuangan,
                        semester!,
                        tahun!,
                      );
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text("Data tidak lengkap")),
                      // );
                      // showCustomSnackbar(context, "Data tidak lengkap");
                      showSnackbar(
                          context, 'Error', 'Data tidak lengkap', 'error');
                    }
                  },
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      child: Icon(
                        Icons.info_rounded,
                        color: greyDarkColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Kode Ruangan $idRuangan ',
                      style: greyDarkTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
