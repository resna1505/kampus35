import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class ThesisPage extends StatelessWidget {
  const ThesisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: whiteColor,
        title: Text(
          'Bimbingan Tugas Akhir',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul Skripsi',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            Text(
              'PENERAPAN ALGORITMA GENETIKA DALAM OPTIMASI PENJADWALAN TUGAS PADA CLOUD COMPUTING',
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Topik',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            Text(
              '-',
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Dosen Pembimbing',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            Text(
              '1. Dr. MUHAMMAD ROPIANTO, S.Kom,. M.Kom.',
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            Text(
              '2. HANAFI, S.Kom,. M.Kom.',
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Abstrak',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            Text(
              'Belum Diisi',
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
