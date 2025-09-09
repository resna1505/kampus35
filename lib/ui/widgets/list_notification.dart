import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class ListNotification extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final String date;
  final VoidCallback? ontap;

  const ListNotification({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.date,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/notification.jpg',
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(4),
                      shape: BoxShape.circle,
                      color: whiteColor,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 14,
                        color: blueDarkColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      subTitle,
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      date,
                      style: greyTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: greySoftColor,
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
