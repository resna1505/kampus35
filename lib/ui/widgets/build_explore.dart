import 'package:d_chart/commons/axis/axis.dart';
import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/commons/viewport.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/grafik_nilai/grafik_nilai_bloc.dart';
import 'package:kampus/blocs/header_explorer/header_explorer_bloc.dart';
import 'package:kampus/blocs/history_sks/history_sks_bloc.dart';
import 'package:kampus/blocs/indeks_prestasi/indeks_prestasi_bloc.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class BuildExplore extends StatelessWidget {
  const BuildExplore({super.key});

  @override
  Widget build(context) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
          BlocProvider(
            create: (context) => HeaderExplorerBloc()..add(HeaderExplorerGet()),
            child: BlocBuilder<HeaderExplorerBloc, HeaderExplorerState>(
              builder: (context, state) {
                if (state is HeaderExplorerLoading) {
                  return Container(
                    padding: const EdgeInsets.all(22),
                    alignment: Alignment.centerLeft,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 18),
                          Skeleton(height: 12, width: 120),
                          SizedBox(height: 8),
                          Skeleton(height: 12, width: 180),
                          SizedBox(height: 8),
                          Skeleton(height: 12, width: 280),
                          SizedBox(height: 8),
                          Skeleton(height: 12, width: 70),
                        ],
                      ),
                    ),
                  );
                } else if (state is HeaderExplorerSuccess) {
                  return Container(
                    padding: const EdgeInsets.all(22),
                    color: Colors.blue.shade50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.headerexplorer.nama.toString(),
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
                              'semester ${state.headerexplorer.semester.toString()}',
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
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 22),
            child: BlocProvider(
              create: (context) =>
                  IndeksPrestasiBloc()..add(IndeksPrestasiGet()),
              child: BlocBuilder<IndeksPrestasiBloc, IndeksPrestasiState>(
                builder: (context, state) {
                  if (state is IndeksPrestasiLoading) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Skeleton(height: 12, width: 115),
                            SizedBox(height: 8),
                            Skeleton(height: 12, width: 180),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Skeleton(height: 115, width: 115),
                                SizedBox(width: 8),
                                Skeleton(height: 115, width: 115),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is IndeksPrestasiSuccess) {
                    return Column(
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
                          'IP yang di peroleh di semester ${state.indeksprestasi.semester.toString()} ',
                          style: blueTextStyle.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
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
                                      style: blackTextStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      state.indeksprestasi.ipsnew.toString(),
                                      style: blackTextStyle.copyWith(
                                        fontSize: 32,
                                        fontWeight: semiBold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        state.indeksprestasi.ipsold
                                                .toString()
                                                .contains('-')
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_down_outlined,
                                                    color: redColor,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    state.indeksprestasi.ipsold
                                                        .toString(),
                                                    style: redTextStyle
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_up_outlined,
                                                    color: greenColor,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    state.indeksprestasi.ipsold
                                                        .toString(),
                                                    style: greenTextStyle
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
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
                                      style: blackTextStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      state.indeksprestasi.ipknew.toString(),
                                      style: blackTextStyle.copyWith(
                                        fontSize: 32,
                                        fontWeight: semiBold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        state.indeksprestasi.ipkold
                                                .toString()
                                                .contains('-')
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_down_outlined,
                                                    color: redColor,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    state.indeksprestasi.ipkold
                                                        .toString(),
                                                    style: redTextStyle
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_up_outlined,
                                                    color: greenColor,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    state.indeksprestasi.ipkold
                                                        .toString(),
                                                    style: greenTextStyle
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          BlocProvider(
            create: (context) => HistorySksBloc()..add(HistorySksGet()),
            child: BlocBuilder<HistorySksBloc, HistorySksState>(
              builder: (context, state) {
                if (state is HistorySksLoading) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Skeleton(height: 12, width: 60),
                          SizedBox(height: 8),
                          Skeleton(height: 12, width: 180),
                          SizedBox(height: 8),
                          Skeleton(height: 115, width: 290),
                        ],
                      ),
                    ),
                  );
                } else if (state is HistorySksSuccess) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: greySoftColor, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SKS',
                          style: blackTextStyle.copyWith(fontSize: 15),
                        ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total SKS telah ditempuh',
                                        style: blackTextStyle.copyWith(
                                          fontSize: 15,
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                      Text(
                                        'SKS Lulus Minimal ${state.historysks.sksmin.toString()} SKS',
                                        style: blueTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    state.historysks.totalsks.toString(),
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
                                  border: Border.all(
                                    color: greySoftColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SKS Lulus',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    state.historysks.skslulus.toString(),
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SKS Mengulang',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    state.historysks.sksmengulang.toString(),
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: BlocProvider(
              create: (context) => GrafikNilaiBloc()..add(GrafikNilaiGet()),
              child: BlocBuilder<GrafikNilaiBloc, GrafikNilaiState>(
                builder: (context, state) {
                  if (state is GrafikNilaiLoading) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Skeleton(height: 12, width: 150),
                            SizedBox(height: 8),
                            Skeleton(height: 12, width: 250),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Skeleton(height: 115, width: 45),
                                SizedBox(width: 30),
                                Skeleton(height: 115, width: 45),
                                SizedBox(width: 30),
                                Skeleton(height: 115, width: 45),
                                SizedBox(width: 30),
                                Skeleton(height: 115, width: 45),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is GrafikNilaiSuccess) {
                    List<OrdinalGroup> ordinalGroup = [
                      OrdinalGroup(
                        id: '1',
                        data: state.grafiknilai
                            .map(
                              (item) => OrdinalData(
                                domain: item.thsmsTrakm, // domain dari semester
                                measure: item.nilaiIpk
                                    .toDouble(), // convert nilaiIPK ke double
                              ),
                            )
                            .toList(),
                      ),
                    ];

                    return Column(
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
                            animationDuration: const Duration(milliseconds: 10),
                            fillColor: (group, ordinalData, index) {
                              if (ordinalData.measure > 0) return blueSoftColor;
                              return blueSoftColor;
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
