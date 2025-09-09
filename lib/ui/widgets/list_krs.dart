import 'package:flutter/material.dart';
import 'package:kampus/models/krs_model.dart';
import 'package:kampus/shared/theme.dart';

class ListKrs extends StatelessWidget {
  // final String title;
  // final String code;
  // final String sks;
  // final String time;
  final KrsModel krsMethod;

  const ListKrs({
    super.key,
    required this.krsMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: greyColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            krsMethod.namamakul.toString(),
            style: blackTextStyle.copyWith(
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Text(
                krsMethod.idmakul.toString(),
                style: greyDarkTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Text(
                  ' - ${krsMethod.sksmakul}SKS',
                  style: greyDarkTextStyle.copyWith(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          Text(
            krsMethod.name?.toString() ?? '-',
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
