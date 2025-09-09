import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/nilai/nilai_bloc.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/list_nilai.dart';
import 'package:http/http.dart' as http;

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  // _AssessmentPageState() {
  //   _selectedVal = _productSizeList[0];
  // }

  // final _productController = TextEditingController();
  // final _productDesController = TextEditingController();
  // bool? _topProduct = false;
  // ProductTypeEnum? _productTypeEnum;

  // final _productSizeList = [
  //   '2024',
  //   '2023',
  //   '2022',
  //   '2021',
  //   '2020',
  //   '2019',
  // ];
  // String _selectedVal = "2021/2022 Genap";
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
    context.read<NilaiBloc>().add(NilaiGet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          'Nilai',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: RefreshIndicator(
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
                    _selectedTahun = _productSizeList.firstWhere(
                        (e) => e['tahunakademik'] == val)['tahunajaran'];
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
            SizedBox(
              height: 590,
              child: SingleChildScrollView(
                // scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: BlocProvider(
                    create: (context) => NilaiBloc()..add(NilaiGet()),
                    child: BlocBuilder<NilaiBloc, NilaiState>(
                      builder: (context, state) {
                        if (state is NilaiSuccess) {
                          // final filteredNilai = state.nilai
                          //     .where((nilaiMethod) =>
                          //         nilaiMethod.tahun == _selectedVal)
                          //     .toList();

                          final filteredNilai =
                              state.nilai.where((nilaiMethod) {
                            return nilaiMethod.tahun == _selectedTahun &&
                                nilaiMethod.semester == _selectedSemester;
                          }).toList();

                          if (filteredNilai.isEmpty) {
                            return Center(
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
                                      style:
                                          blackTextStyle.copyWith(fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: 'Nilai Aktif',
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
                            );
                          }

                          return Column(
                            children: filteredNilai.map((nilaiMethod) {
                              return ListNilai(nilaiMethod: nilaiMethod);
                            }).toList(),
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
