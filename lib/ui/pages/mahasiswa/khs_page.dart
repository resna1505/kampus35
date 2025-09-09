import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/khs/khs_bloc.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/datatable_khs.dart';
import 'package:kampus/ui/widgets/header_nilai.dart';
import 'package:http/http.dart' as http;

class KHSPage extends StatefulWidget {
  const KHSPage({super.key});

  @override
  State<KHSPage> createState() => _KHSPageState();
}

class _KHSPageState extends State<KHSPage> {
  // _KHSPageState() {
  //   _selectedVal = _productSizeList[0];
  // }
  List<Map<String, dynamic>> _productSizeList = [];
  String _selectedTahunAkademik = '';
  String _selectedTahun = '';
  String _selectedSemester = '';

  @override
  void initState() {
    super.initState();
    fetchProductSizeList();
  }

  Future<void> fetchProductSizeList() async {
    final idmhs = await AuthService().getIdMahasiswa();
    final url = '$baseUrl/mahasiswa/tahunakademik/$idmhs';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _productSizeList = List.from(data).cast<Map<String, dynamic>>();

        if (_productSizeList.isNotEmpty) {
          _selectedTahunAkademik = _productSizeList[0]['tahunakademik'];
          _selectedTahun = _productSizeList[0]['tahunajaran'];
          _selectedSemester = _productSizeList[0]['semester'];
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData(BuildContext context) async {
    context.read<KhsBloc>().add(KhsGet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'KHS',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => KhsBloc()..add(KhsGet()),
        child: BlocBuilder<KhsBloc, KhsState>(
          builder: (context, state) {
            if (state is KhsSuccess) {
              final filteredkhs = state.khs.where((khsmethod) {
                return khsmethod.tahun == _selectedTahun &&
                    khsmethod.semester == _selectedSemester;
              }).toList();

              // final filteredkhs = state.khs
              //     .where((khsMethod) => khsMethod.tahun == _selectedVal)
              //     .toList();
              return RefreshIndicator(
                onRefresh: () => _refreshData(context),
                child: ListView(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(12),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       DropdownButtonFormField(
                    //         value: _selectedVal,
                    //         items: _productSizeList
                    //             .map(
                    //               (e) => DropdownMenuItem(
                    //                 child: Text(e),
                    //                 value: e,
                    //               ),
                    //             )
                    //             .toList(),
                    //         onChanged: (val) {
                    //           setState(
                    //             () {
                    //               _selectedVal = val as String;
                    //             },
                    //           );
                    //         },
                    //         icon: Icon(
                    //           Icons.arrow_drop_down_circle,
                    //           color: purpleColor,
                    //         ),
                    //         // dropdownColor: Colors.blue.shade50,
                    //         decoration: const InputDecoration(
                    //           labelText: 'Pilih Periode',
                    //           border: InputBorder.none,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: DropdownButtonFormField<String>(
                        value: _selectedTahunAkademik.isNotEmpty
                            ? _selectedTahunAkademik
                            : null,
                        items: _productSizeList.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['tahunakademik'],
                            child: Text(e['tahunakademik']),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedTahunAkademik = val ?? '';
                            _selectedTahun = _productSizeList.firstWhere((e) =>
                                e['tahunakademik'] == val)['tahunajaran'];
                            _selectedSemester = _productSizeList.firstWhere(
                                (e) => e['tahunakademik'] == val)['semester'];
                          });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down_circle,
                          color: purpleColor,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Pilih Tahun Akademik',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // HeaderNilai(
                        //   title: 'TOTAL SKS',
                        //   value: '6',
                        //   color: 1,
                        // ),
                        HeaderNilai(
                          title: 'SKS DIAMBIL',
                          value: filteredkhs.isNotEmpty
                              ? filteredkhs
                                  .map((khsMethod) =>
                                      int.parse(khsMethod.sksmakul ?? '0'))
                                  .reduce((a, b) => a + b)
                                  .toString()
                              : '0',
                          color: 1,
                        ),
                        HeaderNilai(
                          title: 'IPS',
                          value: filteredkhs.isNotEmpty
                              ? (filteredkhs
                                          .map((khsMethod) => double.parse(
                                              khsMethod.bobot ?? '0.0'))
                                          .reduce((a, b) => a + b) /
                                      filteredkhs.length)
                                  .toStringAsFixed(2)
                              : '0.00',
                          color: 2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 540,
                      child: SingleChildScrollView(
                        child: filteredkhs.isEmpty
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      margin: const EdgeInsets.only(top: 12),
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
                                    const SizedBox(height: 8),
                                    Text.rich(
                                      TextSpan(
                                        text:
                                            'Oops! Looks like you don’t have\nany ',
                                        style: blackTextStyle.copyWith(
                                            fontSize: 12),
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
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  DataTableKHS(khsList: filteredkhs),
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
