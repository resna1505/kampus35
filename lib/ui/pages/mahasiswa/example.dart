import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kampus/shared/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class MySchedule extends StatefulWidget {
  const MySchedule({super.key});

  @override
  State<MySchedule> createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  DateTime today = DateTime.now();
  List<dynamic> monthlyScheduleData = [];
  Map<DateTime, List<dynamic>> events = {};

  @override
  void initState() {
    super.initState();
    fetchMonthlySchedule(today);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = DateTime(day.year, day.month, day.day);
    });
  }

  Future<void> fetchMonthlySchedule(DateTime day) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://ams-api.univbatam.ac.id/index.php/mahasiswa/jadwalperbulan'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "id": 61123148,
          "year": day.year,
          "month": day.month,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data dari API: $data"); // Debugging

        setState(() {
          monthlyScheduleData = data;
          events = {};

          for (var item in monthlyScheduleData) {
            DateTime scheduleDate = DateTime.parse(item['TANGGAL']);
            scheduleDate = DateTime(
                scheduleDate.year, scheduleDate.month, scheduleDate.day);
            if (events[scheduleDate] == null) {
              events[scheduleDate] = [];
            }
            events[scheduleDate]?.add(item);
          }

          print("Events: $events"); // Debugging
        });
      } else {
        print("Gagal mengambil data dari API: ${response.statusCode}");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: whiteColor,
        title: Text(
          'My Schedule',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TableCalendar(
          locale: "en_US",
          rowHeight: 43,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          availableGestures: AvailableGestures.all,
          selectedDayPredicate: (day) => isSameDay(day, today),
          focusedDay: today,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          onDaySelected: _onDaySelected,
          eventLoader: (day) {
            DateTime dateWithoutTime = DateTime(day.year, day.month, day.day);
            return events[dateWithoutTime] ??
                []; // Mengambil event berdasarkan tanggal
          },
          onPageChanged: (focusedDay) {
            fetchMonthlySchedule(focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: (events[today]?.isEmpty ?? true)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal Kelas',
                      style: greyTextStyle.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(today),
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/img_no_data.png'),
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Oops! Looks like you don’t have\nany ',
                            style: blackTextStyle.copyWith(fontSize: 12),
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
                                style: blackTextStyle.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal Kelas',
                      style: greyTextStyle.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(today),
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          events[DateTime(today.year, today.month, today.day)]
                                  ?.length ??
                              0,
                      itemBuilder: (context, index) {
                        final schedule = events[DateTime(
                            today.year, today.month, today.day)]![index];
                        return ListTile(
                          title: Text(schedule['NAMA']),
                          subtitle: Text(
                            '${schedule['MULAI']} - ${schedule['SELESAI']} di ${schedule['NAMARUANGAN']}',
                          ),
                        );
                      },
                    ),
                  ],
                ),
        )
      ],
    );
  }
}
