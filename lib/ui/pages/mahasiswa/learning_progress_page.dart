import 'package:d_chart/commons/axis/axis.dart';
import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/commons/viewport.dart';
import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';
import 'package:d_chart/ordinal/bar.dart';

List<OrdinalData> ordinalList = [
  OrdinalData(domain: '1', measure: 3.25),
  OrdinalData(domain: '2', measure: 2.75),
  OrdinalData(domain: '3', measure: 3.55),
  OrdinalData(domain: '4', measure: 3.85),
  OrdinalData(domain: '5', measure: 2.95),
  OrdinalData(domain: '6', measure: 3.75),
  OrdinalData(domain: '7', measure: 3.55),
  OrdinalData(domain: '8', measure: 3.85),
];

final ordinalGroup = [OrdinalGroup(id: '1', data: ordinalList)];

class LearningProgress extends StatelessWidget {
  const LearningProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          'Kemajuan Belajar',
          style: blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RESNA TRI PANGESTU',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Sekarang kamu ada di ',
                      style: blackTextStyle.copyWith(fontSize: 13),
                    ),
                    Text(
                      'semester 6',
                      style: blackTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Kamu bisa lihat progress perkuliahanmu di bawah ini.',
                  style: blackTextStyle.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Indeks Prestasi',
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  'IP yang di peroleh di semester 5',
                  style: blueTextStyle.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.only(left: 4, top: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: 115,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 3),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IPS',
                                style: blackTextStyle.copyWith(fontSize: 16),
                              ),
                              Text(
                                '3.25',
                                style: blackTextStyle.copyWith(
                                  fontSize: 32,
                                  fontWeight: semiBold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_circle_down_outlined,
                                    color: redColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '-0.57',
                                    style: redTextStyle.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: 115,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 3),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IPK',
                                style: blackTextStyle.copyWith(fontSize: 16),
                              ),
                              Text(
                                '3.56',
                                style: blackTextStyle.copyWith(
                                  fontSize: 32,
                                  fontWeight: semiBold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_circle_up_outlined,
                                    color: greenColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '-0.57',
                                    style: greenTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: 115,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 3),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IPK Lulus',
                                style: blackTextStyle.copyWith(fontSize: 16),
                              ),
                              Text(
                                '3.58',
                                style: blackTextStyle.copyWith(
                                  fontSize: 32,
                                  fontWeight: semiBold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_circle_down_outlined,
                                    color: redColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '-0.21',
                                    style: redTextStyle.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: greySoftColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SKS', style: blackTextStyle.copyWith(fontSize: 15)),
                Text(
                  'SKS-mu sampai semester lalu',
                  style: blueTextStyle.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteColor,
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 5.0),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total SKS telah ditempuh',
                                style: blackTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: semiBold,
                                ),
                              ),
                              Text(
                                'SKS Lulus Minimal 140 SKS',
                                style: blueTextStyle.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            '145',
                            style: blackTextStyle.copyWith(
                              fontSize: 30,
                              fontWeight: semiBold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: greySoftColor, width: 1),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SKS Lulus',
                            style: blackTextStyle.copyWith(fontSize: 12),
                          ),
                          Text(
                            '143',
                            style: blackTextStyle.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SKS Mengulang',
                            style: blackTextStyle.copyWith(fontSize: 12),
                          ),
                          Text(
                            '2',
                            style: blackTextStyle.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perbandingan Nilai',
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  'Nilai yang kamu peroleh sampai sekarang',
                  style: blueTextStyle.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 8),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartBarO(
                    groupList: ordinalGroup,
                    domainAxis: DomainAxis(
                      ordinalViewport: OrdinalViewport('1', 4),
                    ),
                    measureAxis: const MeasureAxis(
                      numericViewport: NumericViewport(0, 4),
                    ),
                    allowSliding: true,
                    barLabelValue: (group, ordinalData, index) {
                      return ordinalData.measure.toString();
                    },
                    animate: true,
                    animationDuration: const Duration(milliseconds: 300),
                    fillColor: (group, ordinalData, index) {
                      if (ordinalData.measure > 0) return blueSoftColor;
                      return blueSoftColor;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
