import 'package:flutter/material.dart';
import 'package:kampus/models/campus_news_model.dart';
import 'package:kampus/shared/theme.dart';

class ListCampusNews extends StatelessWidget {
  // final String logo;
  // final String header;
  // final String mitra;
  // final String time;
  final String img;
  // final String title;
  // final String subtitle;
  final CampusNewsModel campusNewsMethod;
  final VoidCallback? onTap;

  const ListCampusNews({
    super.key,
    // required this.logo,
    // required this.header,
    // required this.mitra,
    // required this.time,
    this.img = 'assets/berita_kampus.jpg',
    // required this.title,
    // required this.subtitle,
    required this.campusNewsMethod,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: whiteColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/logo_uniba.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Universitas Batam',
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Added News on',
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    // Text(
                    //   'mitra',
                    //   style: blackTextStyle.copyWith(
                    //     fontSize: 12,
                    //     fontWeight: medium,
                    //   ),
                    // ),
                    Text(
                      campusNewsMethod.tanggal.toString(),
                      style: greyTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    img,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Text(
                    campusNewsMethod.judul.toString(),
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    (campusNewsMethod.sinopsis?.length ?? 0) > 210
                        ? campusNewsMethod.sinopsis!.substring(0, 210) + '...'
                        : campusNewsMethod.sinopsis ?? '',
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
