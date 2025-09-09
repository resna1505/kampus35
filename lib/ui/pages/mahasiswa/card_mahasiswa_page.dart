import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/biodata/biodata_bloc.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

class CardMahasiswaPage extends StatelessWidget {
  const CardMahasiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Kartu Tanda Mahasiswa',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => BiodataBloc()..add(BiodataGet()),
        child: BlocBuilder<BiodataBloc, BiodataState>(
          builder: (context, state) {
            if (state is BiodataLoading) {
              return Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 18),
                      Skeleton(
                        height: 170,
                        width: 170,
                      ),
                      SizedBox(height: 8),
                      Skeleton(
                        height: 12,
                        width: 180,
                      ),
                      SizedBox(height: 8),
                      Skeleton(
                        height: 300,
                        width: 280,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is BiodataSuccess) {
              return ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 22,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: whiteColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4.0,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: state.biodata.idmhs.toString(),
                          version: QrVersions.auto,
                          size: 170,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Scan QR Code for Attendance',
                        style: greyTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 24,
                      top: 24,
                      right: 24,
                      bottom: 215,
                    ),
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
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      // decoration: const BoxDecoration(
                      //   shape: BoxShape.rectangle,
                      //   image: DecorationImage(
                      //     image: AssetImage(
                      //       'assets/img_card_mahasiswa.png',
                      //     ),
                      //   ),
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: greyDarkTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: regular,
                                ),
                              ),
                              Text(
                                state.biodata.nama.toString().length > 18
                                    ? '${state.biodata.nama.toString().substring(0, 18)}...'
                                    : state.biodata.nama.toString(),
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Student Number',
                                style: greyDarkTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: regular,
                                ),
                              ),
                              Text(
                                state.biodata.idmhs.toString(),
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Major',
                                style: greyDarkTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: regular,
                                ),
                              ),
                              Text(
                                state.biodata.namaprodi.toString(),
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 93,
                            height: 180,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  '${state.biodata.foto.toString()}',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
    );
  }
}
