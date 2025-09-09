import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class NotificationDetail extends StatelessWidget {
  const NotificationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Information Detail',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ListView(
        children: [
          // const SizedBox(
          //   height: 12,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/ic_news1.png',
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
                      'Pembuatan KRS',
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
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
                          'Resna Tri Pangestu M.Kom',
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
                      'Tidak bisa membuat KRS di karenakan sebagai berikut caranya bagaimana ya agar bisa membuat KRS',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      '1 Attachment',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                    Container(
                      color: greySoftColor,
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.description_sharp,
                              color: blueDarkColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Uas Metnum.docx',
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
