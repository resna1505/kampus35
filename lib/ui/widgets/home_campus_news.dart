import 'package:flutter/material.dart';
import 'package:kampus/models/campus_news_model.dart';
import 'package:kampus/shared/theme.dart';

class HomeCampusNews extends StatelessWidget {
  // final String imgUrl;
  // final String title;
  // final String subtitle;
  final CampusNewsModel campusNewsMethod;
  final VoidCallback? onTap;

  const HomeCampusNews({
    super.key,
    // required this.imgUrl,
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
        margin: const EdgeInsets.all(5),
        width: 230,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 130,
              width: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/berita_kampus.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campusNewsMethod.judul.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    (campusNewsMethod.sinopsis?.length ?? 0) > 130
                        ? campusNewsMethod.sinopsis!.substring(0, 130) + '...'
                        : campusNewsMethod.sinopsis ?? '',
                    style: blackTextStyle.copyWith(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
