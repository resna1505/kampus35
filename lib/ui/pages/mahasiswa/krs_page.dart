import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/krs/krs_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/header_nilai.dart';
import 'package:kampus/ui/widgets/list_krs.dart';

class KRSPage extends StatefulWidget {
  const KRSPage({Key? key}) : super(key: key);

  @override
  State<KRSPage> createState() => _KRSPageState();
}

class _KRSPageState extends State<KRSPage> {
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
    context.read<KrsBloc>().add(KrsGet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: whiteColor,
        title: Text(
          'KRS',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => KrsBloc()..add(KrsGet()),
        child: BlocBuilder<KrsBloc, KrsState>(builder: (context, state) {
          if (state is KrsSuccess) {
            final filteredKrs = state.krs.where((krsMethod) {
              return krsMethod.tahun == _selectedTahun &&
                  krsMethod.semester == _selectedSemester;
            }).toList();

            return RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: ListView(
                children: [
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
                  Row(
                    children: [
                      HeaderNilai(
                        title: 'SKS DIAMBIL',
                        value: filteredKrs.isNotEmpty
                            ? filteredKrs
                                .map((krsMethod) =>
                                    int.parse(krsMethod.sksmakul ?? '0'))
                                .reduce((a, b) => a + b)
                                .toString()
                            : '0',
                        color: 1,
                      ),
                      const HeaderNilai(
                        title: 'BATAS SKS',
                        value: '24',
                        color: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 550,
                    child: SingleChildScrollView(
                      child: filteredKrs.isEmpty
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
                                            'assets/img_no_data.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text.rich(
                                    TextSpan(
                                      text:
                                          'Oops! Sepertinya kamu tidak\nmemiliki ',
                                      style:
                                          blackTextStyle.copyWith(fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: 'jadwal aktif',
                                          style: blueTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' hari ini',
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
                              children: filteredKrs.map((krsMethod) {
                                return ListKrs(krsMethod: krsMethod);
                              }).toList(),
                            ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        }),
      ),
    );
  }
}
