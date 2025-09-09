import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/transcript/transcript_bloc.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/datatable_transcript.dart';
import 'package:kampus/ui/widgets/header_nilai.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  _TranscriptPageState() {
    // _selectedVal = _productSizeList[0];
  }

  // final _productController = TextEditingController();
  // final _productDesController = TextEditingController();
  // bool? _topProduct = false;
  // ProductTypeEnum? _productTypeEnum;

  // final _productSizeList = [
  //   '2021/2022 Genap',
  //   '2021/2022 Gasal',
  //   '2020/2021 Genap',
  //   '2020/2021 Gasal',
  //   '2019/2020 Genap',
  //   '2019/2020 Gasal',
  // ];
  // String _selectedVal = "2021/2022 Genap";

  Future<void> _refreshData(BuildContext context) async {
    context.read<TranscriptBloc>().add(TranscriptGet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Transkrip',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => TranscriptBloc()..add(TranscriptGet()),
        child: BlocBuilder<TranscriptBloc, TranscriptState>(
          builder: (context, state) {
            if (state is TranscriptLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TranscriptSuccess) {
              final totalSks = state.transcript
                  .map((transcriptMethod) =>
                      int.parse(transcriptMethod.sksmakul ?? '0'))
                  .reduce((a, b) => a + b);

              final totalBobot = state.transcript.map((transcriptMethod) {
                final nilai = double.parse(transcriptMethod.bobot ?? '0');
                final sks = int.parse(transcriptMethod.sksmakul ?? '0');
                return nilai * sks;
              }).reduce((a, b) => a + b);

              final ipk = totalSks > 0 ? totalBobot / totalSks : 0;

              return RefreshIndicator(
                onRefresh: () => _refreshData(context),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        HeaderNilai(
                          title: 'TOTAL SKS',
                          value: totalSks.toString(),
                          color: 1,
                        ),
                        HeaderNilai(
                          title: 'IPK',
                          value: ipk.toStringAsFixed(2),
                          color: 2,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 600,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DataTableTranscript(
                                transcriptList: state.transcript),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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
