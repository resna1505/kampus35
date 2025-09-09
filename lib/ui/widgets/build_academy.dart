import 'package:flutter/material.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/home_academy_item.dart';
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class BuildAcademy extends StatefulWidget {
  const BuildAcademy({super.key});

  @override
  State<BuildAcademy> createState() => _BuildAcademyState();
}

class _BuildAcademyState extends State<BuildAcademy> {
  bool _isLoading = true;
  String _staseMhs = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(seconds: 1));
    final stase = await AuthService().getStase();

    setState(() {
      _isLoading = false;
      _staseMhs = stase;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 1), () {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
      ),
      child: _isLoading
          ? Container(
              alignment: Alignment.centerLeft,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.white,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(
                      height: 12,
                      width: 180,
                    ),
                    SizedBox(height: 8),
                    Skeleton(
                      height: 12,
                      width: 210,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Skeleton(
                          height: 90,
                          width: 90,
                        ),
                        SizedBox(width: 14),
                        Skeleton(
                          height: 90,
                          width: 90,
                        ),
                        SizedBox(width: 14),
                        Skeleton(
                          height: 90,
                          width: 90,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Skeleton(
                          height: 90,
                          width: 90,
                        ),
                        SizedBox(width: 14),
                        Skeleton(
                          height: 90,
                          width: 90,
                        ),
                        SizedBox(width: 14),
                        Skeleton(
                          height: 90,
                          width: 90,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Academy Access',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  'Your easy access of academy needs',
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeAcademyItem(
                      iconUrl: 'assets/ic_ktm.png',
                      title: 'Kartu\nMahasiswa',
                      color: const Color(0xffFFF1D3),
                      onTap: () {
                        Navigator.pushNamed(context, '/card-mahasiswa');
                      },
                    ),
                    HomeAcademyItem(
                      iconUrl: 'assets/ic_keuangan.png',
                      title: 'Riwayat\nPembayaran',
                      color: const Color(0xffD9F1E4),
                      onTap: () {
                        Navigator.pushNamed(context, '/invoice-payment');
                      },
                    ),
                    HomeAcademyItem(
                      iconUrl: 'assets/ic_krs.png',
                      title: 'KRS',
                      color: const Color(0xffEEF5F8),
                      onTap: () {
                        Navigator.pushNamed(context, '/krs');
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeAcademyItem(
                      iconUrl: 'assets/ic_khs.png',
                      title: 'KHS',
                      color: const Color(0xffF5F8FF),
                      onTap: () {
                        Navigator.pushNamed(context, '/khs');
                      },
                    ),
                    HomeAcademyItem(
                      iconUrl: 'assets/ic_transkrip.png',
                      title: 'Transkrip',
                      color: const Color(0xffEBDBD8),
                      onTap: () {
                        Navigator.pushNamed(context, '/transcript');
                      },
                    ),
                    HomeAcademyItem(
                      iconUrl: 'assets/ic_nilai.png',
                      title: 'Nilai',
                      color: const Color(0xffC1DAE6),
                      onTap: () {
                        Navigator.pushNamed(context, '/assessment');
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                // HomeAcademyItem(
                //   iconUrl: 'assets/ic_kemajuan.png',
                //   title: 'Kemajuan\nBelajar',
                //   color: const Color(0xffE4F1F4),
                //   onTap: () {
                //     Navigator.pushNamed(context, '/learning-progress');
                //   },
                // ),
                // HomeAcademyItem(
                //   iconUrl: 'assets/ic_bimbingan.png',
                //   title: 'Bimbingan\nTugas Akhir',
                //   color: const Color(0xffFFEDBD),
                //   onTap: () {
                //     Navigator.pushNamed(context, '/thesis');
                //   },
                // ),
                // HomeAcademyItem(
                //   iconUrl: 'assets/ic_konsultasi.png',
                //   title: 'Konsultasi\nDosen',
                //   color: const Color(0xffC1FBE4),
                //   onTap: () {
                //     Navigator.pushNamed(context, '/lecturer-consultation');
                //   },
                // ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 12,
                // ),
                if (_staseMhs == '0')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HomeAcademyItem(
                        iconUrl: 'assets/ic_input_krs.png',
                        title: 'Pengisian\nKRS',
                        color: const Color(0xffE2E3E4),
                        onTap: () {
                          Navigator.pushNamed(context, '/input-krs');
                        },
                      ),
                    ],
                  )
                else
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HomeAcademyItem(
                        iconUrl: 'assets/ic_input_krs.png',
                        title: 'KRS Stase',
                        color: const Color(0xffE2E3E4),
                        onTap: () {
                          Navigator.pushNamed(context, '/input-krs-stase');
                        },
                      ),
                      HomeAcademyItem(
                        iconUrl: 'assets/ic_input_krs.png',
                        title: 'KRS Stase\nRemedial',
                        color: const Color(0xffE2E3E4),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/input-krs-stase-remedial');
                        },
                      ),
                    ],
                  )
              ],
            ),
    );
  }
}
