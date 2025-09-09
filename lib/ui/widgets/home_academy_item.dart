import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class HomeAcademyItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const HomeAcademyItem({
    super.key,
    required this.iconUrl,
    required this.title,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 64,
            width: 64,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            child: Center(
              child: Image.asset(
                iconUrl,
                width: 40,
                height: 40,
              ),
            ),
          ),
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
