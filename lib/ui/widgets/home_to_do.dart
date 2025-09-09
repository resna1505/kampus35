import 'package:flutter/material.dart';
import 'package:kampus/models/absence_model.dart';
import 'package:kampus/shared/theme.dart';

class HomeToDo extends StatelessWidget {
  // final String title;
  // final String status;
  // final String date;
  final VoidCallback? onTap;

  final AbsenceModel absenceMethod;

  const HomeToDo({
    super.key,
    // required this.title,
    // required this.status,
    // required this.date,
    required this.absenceMethod,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(
          16,
        ),
        margin: const EdgeInsets.only(
          bottom: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: whiteColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/ic_tugas.png',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (absenceMethod.namamakul.toString().length > 23)
                              ? absenceMethod.namamakul
                                      .toString()
                                      .substring(0, 23) +
                                  '...'
                              : absenceMethod.namamakul.toString(),
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          absenceMethod.statusabsen == 0
                              ? 'Incompleted'
                              : 'Completed',
                          style: (absenceMethod.statusabsen == 1)
                              ? blueTextStyle.copyWith(
                                  fontSize: 10,
                                  fontWeight: light,
                                )
                              : redTextStyle.copyWith(
                                  fontSize: 10,
                                  fontWeight: light,
                                ),
                        )
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (absenceMethod.statusabsen == 1)
                                ? whiteColor
                                : redColor,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          absenceMethod.tanggal.toString(),
                          style: greyTextStyle.copyWith(
                            fontSize: 10,
                            fontWeight: light,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: greySoftColor,
                  width: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
