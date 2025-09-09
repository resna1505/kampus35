import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/models/khs_model.dart';

class DataTableKHS extends StatelessWidget {
  final List<KhsModel> khsList;

  const DataTableKHS({
    super.key,
    required this.khsList,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 35,
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
      rows: khsList.map(
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
                  item.sksmakul.toString(),
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ),
              DataCell(
                Text(
                  item.bobot.toString(),
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
