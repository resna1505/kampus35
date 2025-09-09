import 'package:flutter/material.dart';
import 'package:kampus/models/transcript_model.dart';
import 'package:kampus/shared/theme.dart';

class DataTableTranscript extends StatelessWidget {
  final List<TranscriptModel> transcriptList;

  const DataTableTranscript({
    super.key,
    required this.transcriptList,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 30,
      sortColumnIndex: 0,
      sortAscending: true,
      columns: [
        DataColumn(
          label: Text(
            'Mata Kuliah',
            style: blackTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'SKS',
            style: blackTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Nilai',
            style: blackTextStyle.copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Huruf',
            style: blackTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
          numeric: true,
        ),
      ],
      rows: transcriptList.map(
        (item) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  item.namamakul ?? '',
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ),
              DataCell(
                Text(
                  item.sksmakul ?? '',
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ),
              DataCell(
                Text(
                  item.bobot ?? '',
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ),
              DataCell(
                Text(
                  item.simbol ?? '',
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ).toList(),
    );
  }
}
