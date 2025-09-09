import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class InformationDetail extends StatelessWidget {
  final String img;
  final String title;
  final String from;
  final String subtitle;
  final String namefile;

  const InformationDetail({
    super.key,
    this.img = 'assets/berita_kampus.jpg',
    required this.title,
    required this.from,
    required this.subtitle,
    this.namefile = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
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
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greySoftColor,
                    ),
                    child: Icon(
                      Icons.person,
                      color: whiteColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    from,
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                subtitle,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 12,
              ),
              // Text(
              //   '1 Attachment',
              //   style: blackTextStyle.copyWith(
              //     fontSize: 14,
              //     fontWeight: semiBold,
              //   ),
              // ),
              // Container(
              //   color: greySoftColor,
              //   padding: const EdgeInsets.all(4),
              //   child: Row(
              //     children: [
              //       SizedBox(
              //         width: 40,
              //         height: 40,
              //         child: Icon(
              //           Icons.description_sharp,
              //           color: blueDarkColor,
              //           size: 30,
              //         ),
              //       ),
              //       const SizedBox(
              //         width: 4,
              //       ),
              //       Text(
              //         'Uas Metnum.docx',
              //         style: blackTextStyle.copyWith(
              //           fontSize: 14,
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
