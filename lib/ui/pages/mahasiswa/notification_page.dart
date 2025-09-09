import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/list_notification.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Notifikasi',
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
          ListNotification(
            title: 'Ada Info baru @Analisa Dan Perancangan Sistem Informasi II',
            subTitle:
                'Work Plan (Rencana Kerja) Lanjutan work plan Critical Path Method Susuan kerja pada proyek',
            icon: Icons.notifications,
            date: '17 March 2023',
            ontap: () {
              Navigator.pushNamed(context, '/notification-detail');
            },
          ),
          ListNotification(
            title: 'Ada Materi baru @METODE NUMERIK',
            subTitle: 'Perhitungan algoritma dan numerik sederhana',
            icon: Icons.edit_document,
            date: '11 March 2023',
            ontap: () {},
          ),
          ListNotification(
            title: 'Ada Video Conference Baru @Manajemen Proyek',
            subTitle: 'Kisi kisi UAS',
            icon: Icons.video_camera_front,
            date: '02 March 2023',
            ontap: () {},
          ),
          ListNotification(
            title: 'Ada Ujian Baru @Bahasa Inggris',
            subTitle: 'UAS',
            icon: Icons.pending_actions,
            date: '05 January 2023',
            ontap: () {},
          ),
        ],
      ),
    );
  }
}
