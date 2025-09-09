import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kampus/blocs/schedule/schedule_bloc.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/list_schedule.dart';
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class BuildSchedule extends StatefulWidget {
  const BuildSchedule({super.key});

  @override
  State<BuildSchedule> createState() => _BuildScheduleState();
}

class _BuildScheduleState extends State<BuildSchedule> {
  String selectedDay = DateFormat('E').format(DateTime.now());
  DateTime? selectedDate = DateTime.now();

  late DateTime formattedMonday;
  late DateTime formattedTuesday;
  late DateTime formattedWednesday;
  late DateTime formattedThursday;
  late DateTime formattedFriday;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    int mon = now.weekday - DateTime.monday;
    formattedMonday = now.subtract(Duration(days: mon));

    int tue = now.weekday - DateTime.tuesday;
    formattedTuesday = now.subtract(Duration(days: tue));

    int wed = now.weekday - DateTime.wednesday;
    formattedWednesday = now.subtract(Duration(days: wed));

    int thu = now.weekday - DateTime.thursday;
    formattedThursday = now.subtract(Duration(days: thu));

    int fri = now.weekday - DateTime.friday;
    formattedFriday = now.subtract(Duration(days: fri));
  }

  void showDataForDate(DateTime date, String day) {
    setState(() {
      selectedDate = date;
      selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: whiteColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0,
            offset: Offset(
              0,
              -2,
            ),
          ),
        ],
      ),
      child: BlocProvider(
        create: (context) => ScheduleBloc()..add(ScheduleGet()),
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(
                        height: 12,
                        width: 120,
                      ),
                      SizedBox(height: 8),
                      Skeleton(
                        height: 12,
                        width: 280,
                      ),
                      SizedBox(height: 8),
                      Skeleton(
                        height: 150,
                        width: 300,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ScheduleSuccess) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Schedule',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                          Text(
                            'This is your collage class schedule board',
                            style: greyTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/my-schedule');
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: whiteColor,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 6,
                      top: 4,
                      right: 6,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: greySoftColor,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => showDataForDate(formattedMonday, 'Mon'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Mon'
                                  ? purpleColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Senin',
                              style: selectedDay == 'Mon'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () => showDataForDate(formattedTuesday, 'Tue'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Tue'
                                  ? purpleColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Selasa',
                              style: selectedDay == 'Tue'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () =>
                              showDataForDate(formattedWednesday, 'Wed'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Wed'
                                  ? purpleColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Rabu',
                              style: selectedDay == 'Wed'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () =>
                              showDataForDate(formattedThursday, 'Thu'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Thu'
                                  ? purpleColor
                                  : Colors
                                      .transparent, // Warna berubah jika dipilih
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Kamis',
                              style: selectedDay == 'Thu'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () => showDataForDate(formattedFriday, 'Fri'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Fri'
                                  ? purpleColor
                                  : Colors
                                      .transparent, // Warna berubah jika dipilih
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Jumat',
                              style: selectedDay == 'Fri'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // selectedDay == 'Wed'
                  state.schedule.any((schedule) =>
                          schedule.tanggal ==
                          selectedDate?.toIso8601String().substring(0, 10))
                      ? Container(
                          padding: const EdgeInsets.all(
                            18,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                // offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: state.schedule
                                .where((scheduleMethod) =>
                                    scheduleMethod.tanggal ==
                                    selectedDate
                                        ?.toIso8601String()
                                        .substring(0, 10))
                                .map((scheduleMethod) {
                              return ListSchedule(
                                  scheduleMethod: scheduleMethod);
                            }).toList(),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(
                            18,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                // offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'assets/img_no_data.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text:
                                          'Oops ! Looks like you don’t have\nany ',
                                      style: blackTextStyle.copyWith(
                                        fontSize: 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'active schedule',
                                          style: blueTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' this day',
                                          style: blackTextStyle.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                ],
              );
            } else {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Schedule',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                          Text(
                            'This is your collage class schedule board',
                            style: greyTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/my-schedule');
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: whiteColor,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Container(
                  //   padding: const EdgeInsets.only(
                  //     left: 6,
                  //     top: 4,
                  //     right: 6,
                  //     bottom: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(16),
                  //       topRight: Radius.circular(16),
                  //     ),
                  //     color: greySoftColor,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 11,
                  //           vertical: 3,
                  //         ),
                  //         // decoration: BoxDecoration(
                  //         //   borderRadius: BorderRadius.circular(100),
                  //         // ),
                  //         decoration: BoxDecoration(
                  //           color: purpleColor,
                  //           borderRadius: BorderRadius.circular(
                  //               100), // Memberikan radius 100
                  //         ),
                  //         child: Text(
                  //           'Today',
                  //           style: whiteTextStyle.copyWith(
                  //             fontWeight: light,
                  //             fontSize: 12,
                  //           ),
                  //         ),
                  //       ),
                  //       const Spacer(flex: 1),
                  //       Container(
                  //         padding: const EdgeInsets.only(
                  //           right: 11,
                  //           left: 11,
                  //         ),
                  //         child: Text(
                  //           'Mon',
                  //           style: greyTextStyle.copyWith(
                  //             fontWeight: light,
                  //             fontSize: 12,
                  //           ),
                  //         ),
                  //       ),
                  //       const Spacer(flex: 1),
                  //       Container(
                  //         padding: const EdgeInsets.only(
                  //           right: 11,
                  //           left: 11,
                  //         ),
                  //         child: Text(
                  //           'Tue',
                  //           style: greyTextStyle.copyWith(
                  //             fontWeight: light,
                  //             fontSize: 12,
                  //           ),
                  //         ),
                  //       ),
                  //       const Spacer(flex: 1),
                  //       Container(
                  //         padding: const EdgeInsets.only(
                  //           right: 11,
                  //           left: 11,
                  //         ),
                  //         child: Text(
                  //           'Wed',
                  //           style: greyTextStyle.copyWith(
                  //             fontWeight: light,
                  //             fontSize: 12,
                  //           ),
                  //         ),
                  //       ),
                  //       const Spacer(flex: 1),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 11,
                  //           vertical: 3,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(
                  //               100), // Memberikan radius 100
                  //         ),
                  //         child: Text(
                  //           'Thurs',
                  //           style: greyTextStyle.copyWith(
                  //             fontWeight: light,
                  //             fontSize: 12,
                  //           ),
                  //         ),
                  //       ),
                  //       const Spacer(flex: 1),
                  //       Container(
                  //         padding: const EdgeInsets.only(
                  //           right: 11,
                  //           left: 11,
                  //         ),
                  //         child: Text(
                  //           'Fri',
                  //           style: greyTextStyle.copyWith(
                  //             fontWeight: light,
                  //             fontSize: 12,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 6,
                      top: 4,
                      right: 6,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: greySoftColor,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => showDataForDate(DateTime(2024, 10, 14),
                              'Mon'), // Ketika diklik "Mon"
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Mon'
                                  ? purpleColor
                                  : Colors
                                      .transparent, // Warna berubah jika dipilih
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Senin',
                              style: selectedDay == 'Mon'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () => showDataForDate(DateTime(2024, 10, 14),
                              'Tue'), // Ketika diklik "Tue"
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Tue'
                                  ? purpleColor
                                  : Colors
                                      .transparent, // Warna berubah jika dipilih
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Selasa',
                              style: selectedDay == 'Tue'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () => showDataForDate(DateTime(2024, 10, 14),
                              'Wed'), // Ketika diklik "Wed"
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Wed'
                                  ? purpleColor
                                  : Colors
                                      .transparent, // Warna berubah jika dipilih
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Rabu',
                              style: selectedDay == 'Wed'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () => showDataForDate(DateTime(2024, 10, 14),
                              'Thu'), // Ketika diklik "Thu"
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Thu'
                                  ? purpleColor
                                  : Colors
                                      .transparent, // Warna berubah jika dipilih
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Kamis',
                              style: selectedDay == 'Thu'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        InkWell(
                          onTap: () => showDataForDate(DateTime(2024, 10, 14),
                              'Fri'), // Ketika diklik "Fri"
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: selectedDay == 'Fri'
                                  ? purpleColor
                                  : Colors
                                      .transparent, // Warna berubah jika dipilih
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Jumat',
                              style: selectedDay == 'Fri'
                                  ? whiteTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    )
                                  : greyTextStyle.copyWith(
                                      fontWeight: light,
                                      fontSize: 12,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(
                      18,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: whiteColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          // offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/img_no_data.png',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Oops ! Looks like you don’t have\nany ',
                                style: blackTextStyle.copyWith(
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'active schedule',
                                    style: blueTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: semiBold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' this day',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
