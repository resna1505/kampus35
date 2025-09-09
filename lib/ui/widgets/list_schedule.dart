import 'package:flutter/material.dart';
import 'package:kampus/models/schedule_model.dart';
import 'package:kampus/shared/theme.dart';

class ListSchedule extends StatelessWidget {
  // final String title;
  // final String subtitle;
  // final String time;
  final ScheduleModel scheduleMethod;

  const ListSchedule({
    super.key,
    // required this.title,
    // required this.subtitle,
    // required this.time,
    required this.scheduleMethod,
  });

  String wrapText(String text, int maxLength) {
    List<String> words = text.split(' ');
    StringBuffer result = StringBuffer();
    String line = '';

    for (String word in words) {
      if ((line + word).length <= maxLength) {
        line += word + ' ';
      } else {
        if (line.isNotEmpty) {
          result.write(line.trim() + '\n');
        }
        line = word + ' ';
      }
    }

    if (line.isNotEmpty) {
      result.write(line.trim());
    }

    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 11),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: greySoftColor),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wrapText(scheduleMethod.title.toString(), 26),
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                ),
              ),
              Text(
                scheduleMethod.subtitle.toString(),
                style: greyDarkTextStyle.copyWith(
                  fontSize: 10,
                  fontWeight: light,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: purpleColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: Text(
                scheduleMethod.time.toString(),
                style: whiteTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 12,
                  color: purpleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
