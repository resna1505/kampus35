import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class HeaderNilai extends StatelessWidget {
  final String title;
  final String value;
  final int color;

  const HeaderNilai({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color == 1 ? const Color(0xFFC2E3F0) : const Color(0xFFF3DFBE),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: redColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: whiteTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
