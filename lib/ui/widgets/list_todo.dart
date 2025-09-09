import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class ListTodo extends StatelessWidget {
  final String title;
  final String kategori;
  final String ruangan;
  final String time;
  final String status;
  final String date;

  const ListTodo({
    super.key,
    required this.title,
    required this.kategori,
    required this.ruangan,
    required this.time,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: greyColor,
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '$kategori ($ruangan)',
                style: greyDarkTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: greyColor,
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                date,
                style: greyDarkTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Icon(
                Icons.access_time_filled_outlined,
                color: greyColor,
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                time,
                style: greyDarkTextStyle.copyWith(
                  fontSize: 12,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: status == 'Sudah dinilai'
                  ? greenColor
                  : status == 'Dikirim'
                      ? purpleColor
                      : redColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              status,
              style: whiteTextStyle.copyWith(
                fontWeight: light,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
