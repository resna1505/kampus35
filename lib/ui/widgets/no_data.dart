import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class NoData extends StatelessWidget {
  final String? title;

  const NoData({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/img_no_data.png'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: 'Oops! Sepertinya kamu tidak\nmemiliki ',
              style: blackTextStyle.copyWith(fontSize: 12),
              children: [
                TextSpan(
                  text: title,
                  style: blueTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semiBold,
                  ),
                ),
                TextSpan(
                  text: ' hari ini',
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
