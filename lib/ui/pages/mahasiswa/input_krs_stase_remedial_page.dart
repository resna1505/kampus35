import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class InputKRSStaseRemedial extends StatefulWidget {
  const InputKRSStaseRemedial({super.key});

  @override
  State<InputKRSStaseRemedial> createState() => _InputKRSStaseRemedialState();
}

class _InputKRSStaseRemedialState extends State<InputKRSStaseRemedial> {
  int selectedTab = 0;

  List<Map<String, dynamic>> kelas = [];
  List<bool> isCheckedKelas = [];

  List<Map<String, dynamic>> krsTersimpan = [];
  List<bool> isCheckedKrs = [];

  int totalSKS = 0;

  bool _isSubmitting = false;

  // Variabel data dari API
  String semester = '-';
  String batasSKS = '-';
  String periodeAkademik = '-';

  List<Map<String, dynamic>> kelasOptions = [];

  @override
  void initState() {
    super.initState();
    fetchKelasOptions();
    fetchKRSData();
    fetchKRSTersimpan();

    isCheckedKelas = [];
    isCheckedKrs = [];
  }

  Future<void> fetchKelasOptions() async {
    final url = Uri.parse('$baseUrl/akademik/kelas');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          kelasOptions = data.map<Map<String, dynamic>>((item) {
            return {
              'ID': item['ID'] ?? '-',
              'NAMA': item['NAMA'] ?? '-',
            };
          }).toList();
        });
      } else {
        if (mounted) {
          showSnackbar(context, 'Info', 'Gagal mengambil data kelas', 'info');
        }
      }
    } catch (e) {
      debugPrint('Error fetch kelas options: $e');
      if (mounted) {
        showSnackbar(context, 'Error', 'Gagal mengambil data kelas', 'error');
      }
    }
  }

  Future<void> fetchKRSData() async {
    final idmhs = await AuthService().getIdMahasiswa();
    final url = Uri.parse('$baseUrl/mahasiswa/isikrs');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': idmhs,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          semester = data['semester']?.toString() ?? '-';
          batasSKS = data['batas_sks']?.toString() ?? '-';
          periodeAkademik = data['tahun_ajaran'] ?? '-';
          totalSKS = int.tryParse(data['batas_sks'].toString()) ?? 0;

          final List<dynamic> mataKuliahData = data['mata_kuliah'] ?? [];

          kelas = mataKuliahData.map<Map<String, dynamic>>((item) {
            return {
              'id': item['ID'] ?? '-',
              'nama': item['NAMA'] ?? '-',
              'kdwpltbkmk': item['KDWPLTBKMK'] ?? '-',
              'sks': item['SKS'] ?? 0,
              'semester': item['SEMESTER'] ?? '-',
              'thsmstbkmk': item['THSMSTBKMK'] ?? '-',
              'idmahasiswa': item['idmahasiswa'] ?? '-',
              'tahunajaran': item['tahunajaran'] ?? '-',
              'semesterajaran': item['semesterajaran'] ?? '-',
              'selectedKelas': item['kelas'] ?? '01',
            };
          }).toList();

          // Reset checkbox list dengan nilai false semua
          isCheckedKelas = List<bool>.filled(kelas.length, false);
        });
      } else {
        final data = jsonDecode(response.body);

        if (mounted) {
          showSnackbar(context, 'Info', data['messages']['error'], 'info');
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> fetchKRSTersimpan() async {
    final idmhs = await AuthService().getIdMahasiswa();
    final url = Uri.parse('$baseUrl/mahasiswa/ambilmatkulkrs');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': idmhs,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          krsTersimpan = data.map<Map<String, dynamic>>((item) {
            return {
              "idmahasiswa": item['IDMAHASISWA'] ?? '-',
              "idmakul": item['IDMAKUL'] ?? '-',
              "nama": item['NAMA'] ?? '-',
              "sks": int.tryParse(item['SKS'].toString()) ?? 0,
              "thnajar": item['THNAJAR'] ?? '-',
              "semester": item['SMSTRAJAR'] ?? '-',
              "thnsm": item['THNSM'] ?? '-',
              "semestermakul": item['SEMESTERMAKUL'] ?? '-',
              "kelas": item['KELAS'] ?? '-',
            };
          }).toList();

          isCheckedKrs = List<bool>.filled(krsTersimpan.length, false);
        });
      } else if (response.statusCode == 404) {
        // Handle 404 response by setting empty data
        setState(() {
          krsTersimpan = [];
          isCheckedKrs = [];
        });
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          showSnackbar(context, 'Info',
              data['messages']['error'] ?? 'Terjadi kesalahan', 'info');
        }
      }
    } catch (e) {
      debugPrint('Error fetch KRS Tersimpan: $e');
      // Handle error by setting empty data
      if (mounted) {
        setState(() {
          krsTersimpan = [];
          isCheckedKrs = [];
        });
        showSnackbar(context, 'Error', 'Gagal memuat data KRS', 'error');
      }
    }
  }

  // Future<void> postKRSData(List<Map<String, dynamic>> selectedCourses) async {
  //   final url = Uri.parse('$baseUrl/mahasiswa/postisikrs');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(selectedCourses),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);

  //       if (mounted) {
  //         showSnackbar(context, 'Success', responseData['message'].toString(),
  //             'success');
  //       }
  //       fetchKRSTersimpan();
  //     } else {
  //       final data = jsonDecode(response.body);

  //       if (mounted) {
  //         showSnackbar(context, 'Info', data['messages']['message'], 'info');
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       showSnackbar(context, 'Error', e.toString(), 'error');
  //     }
  //   }
  // }

  Future<void> postKRSData(List<Map<String, dynamic>> selectedCourses) async {
    final url = Uri.parse('$baseUrl/mahasiswa/postisikrs');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(selectedCourses),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['flag'] == 1) {
          final confirm =
              await showKRSConfirmationModal(responseData['message']);

          if (!confirm) return;

          final confirmUrl = Uri.parse('$baseUrl/mahasiswa/postisikrscfm');
          final confirmResponse = await http.post(
            confirmUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(selectedCourses),
          );

          if (confirmResponse.statusCode == 200) {
            final confirmData = jsonDecode(confirmResponse.body);
            if (mounted) {
              showSnackbar(
                  context, 'Success', confirmData['message'], 'success');
              fetchKRSTersimpan();
            }
          } else {
            final err = jsonDecode(confirmResponse.body);
            if (mounted) {
              showSnackbar(context, 'Info', err['messages']['message'], 'info');
            }
          }
          return;
        }

        if (mounted) {
          showSnackbar(context, 'Success', responseData['message'].toString(),
              'success');
          fetchKRSTersimpan();
        }
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          showSnackbar(context, 'Info', data['messages']['message'], 'info');
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Error', e.toString(), 'error');
      }
    }
  }

  Future<void> hapusKRSData(List<Map<String, dynamic>> selectedKrs) async {
    final url = Uri.parse('$baseUrl/mahasiswa/hapusisikrs');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(selectedKrs),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (mounted) {
          showSnackbar(context, 'Success', responseData['message'].toString(),
              'success');
        }
        fetchKRSTersimpan();
      } else {
        final data = jsonDecode(response.body);

        if (mounted) {
          showSnackbar(context, 'Info', data['messages']['error'], 'info');
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Error', e.toString(), 'error');
      }
    }
  }

  Future<bool> showKRSConfirmationModal(String message) async {
    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                children: [
                  Center(
                    child: Text(
                      'Pengajuan KRS',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      message,
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Apakah anda ingin melanjutkan pengisian KRS?',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Tidak',
                            style: blackTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            'Ya',
                            style: whiteTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = isCheckedKelas.where((e) => e).length;
    int totalSelectedSKS = 0;
    for (int i = 0; i < isCheckedKelas.length; i++) {
      if (isCheckedKelas[i]) {
        // Pastikan data sks di parse dulu ke int
        totalSelectedSKS += int.tryParse(kelas[i]['sks'].toString()) ?? 0;
      }
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: whiteColor,
        title: Text(
          'Kartu Rencana Studi',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Info Box
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoColumn(title: 'Periode', value: periodeAkademik),
                  InfoColumn(title: 'Semester', value: semester),
                  InfoColumn(title: 'Batas SKS', value: batasSKS),
                ],
              ),
            ),
          ),

          // Tabs
          Row(
            children: [
              _buildTabButton('PILIH KRS', 0),
              _buildTabButton('KRS TERSIMPAN', 1),
            ],
          ),

          // Content per tab
          Expanded(
            child: selectedTab == 0
                ? _buildPilihKelas(totalSelectedSKS, selectedCount)
                : _buildKRSTersimpan(totalSelectedSKS),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int tabIndex) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedTab = tabIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: selectedTab == tabIndex ? blueDarkColor : greySoftColor,
          child: Center(
            child: Text(
              title,
              style: (selectedTab == tabIndex ? whiteTextStyle : blackTextStyle)
                  .copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPilihKelas(int totalSelectedSKS, int selectedCount) {
    return Column(
      children: [
        Expanded(
          child: kelas.isEmpty
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
                            image: AssetImage('assets/img_no_data.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text: 'Waktu Pengisian KRS\n ',
                          style: blackTextStyle.copyWith(fontSize: 12),
                          children: [
                            TextSpan(
                              text: 'Belum Dimulai / sudah ditutup',
                              style: blackTextStyle.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: kelas.length,
                  itemBuilder: (context, index) {
                    final item = kelas[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheckedKelas[index],
                              onChanged: (val) {
                                setState(() {
                                  isCheckedKelas[index] = val ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['nama'],
                                      style: blackTextStyle.copyWith(
                                          fontSize: 12, fontWeight: semiBold)),
                                  Text('SKS ${item['sks']} • ${item['id']}',
                                      style: blackTextStyle.copyWith(
                                          fontSize: 12)),
                                  Text('Semester ${item['semester']}',
                                      style: blackTextStyle.copyWith(
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            DropdownButton<String>(
                              value: item['selectedKelas'],
                              items: kelasOptions.map((kelas) {
                                return DropdownMenuItem<String>(
                                  value: kelas['ID'],
                                  child: Text(kelas['NAMA']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  item['selectedKelas'] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$selectedCount Terpilih,\nTersisa ${totalSKS - totalSelectedSKS} SKS dari $totalSKS SKS',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: semiBold,
                ),
              ),
              ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        setState(() {
                          _isSubmitting = true;
                        });

                        final selectedCourses = <Map<String, dynamic>>[];

                        for (int i = 0; i < isCheckedKelas.length; i++) {
                          if (isCheckedKelas[i]) {
                            final matkul = kelas[i];
                            selectedCourses.add({
                              "ID": matkul['id'],
                              "NAMA": matkul['nama'],
                              "KDWPLTBKMK": matkul['kdwpltbkmk'],
                              "SKS": matkul['sks'].toString(),
                              "SEMESTER": matkul['semester'].toString(),
                              "THSMSTBKMK": matkul['thsmstbkmk'].toString(),
                              "KELAS": matkul['selectedKelas'],
                              "idmahasiswa": matkul['idmahasiswa'],
                              "tahunajaran": matkul['tahunajaran'],
                              "semesterajaran": matkul['semesterajaran'],
                            });
                          }
                        }

                        try {
                          if (selectedCourses.isNotEmpty) {
                            await postKRSData(selectedCourses);
                          } else {
                            showSnackbar(context, 'Info',
                                'Pilih minimal 1 mata kuliah', 'info');
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isSubmitting ? Colors.green[300] : Colors.green,
                  foregroundColor: whiteColor,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Simpan',
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: semiBold,
                        ),
                      ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildKRSTersimpan(int totalSelectedSKS) {
    int totalSimpanSKS = krsTersimpan.fold(
      0,
      (sum, item) => sum + (item['sks'] as int),
    );

    return Column(
      children: [
        Expanded(
          child: krsTersimpan.isEmpty
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
                            image: AssetImage('assets/img_no_data.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text: 'Belum ada',
                          style: blackTextStyle.copyWith(fontSize: 12),
                          children: [
                            TextSpan(
                              text: ' Mata Kuliah\n',
                              style: blueTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                              ),
                            ),
                            TextSpan(
                              text: ' Yang di Ambil',
                              style: blackTextStyle.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: krsTersimpan.length,
                  itemBuilder: (context, index) {
                    // final item = krsTersimpan[index];
                    if (index >= krsTersimpan.length ||
                        index >= isCheckedKrs.length) {
                      return const SizedBox();
                    }
                    final item = krsTersimpan[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheckedKrs[index],
                              onChanged: (val) {
                                setState(() {
                                  isCheckedKrs[index] = val ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['nama'],
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: semiBold,
                                    ),
                                  ),
                                  Text(
                                    'SKS ${item['sks']} • ${item['idmakul']} • ${item['kelas']}',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Semester ${item['semester']}',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'KRS telah diajukan ke dosen PA',
                    style: greenTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sudah diambil : ',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                    ),
                    TextSpan(
                      text: '$totalSimpanSKS SKS',
                      style: blueTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                    ),
                    TextSpan(
                      text: '    Tersisa ',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                    ),
                    TextSpan(
                      text: '${totalSKS - totalSimpanSKS} SKS',
                      style: redTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                    ),
                    TextSpan(
                      text: ' dari $totalSKS SKS',
                      style: greyTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        // ElevatedButton.icon(
        //   icon: const Icon(Icons.download),
        //   label: const Text('Download PDF KRS'),
        //   onPressed: krsTersimpan.isEmpty
        //       ? null
        //       : () async {
        //           final hasPermission = await _requestStoragePermission();
        //           if (!hasPermission) {
        //             if (mounted) {
        //               showSnackbar(
        //                   context,
        //                   'Error',
        //                   'Izin penyimpanan diperlukan untuk download PDF',
        //                   'error');
        //             }
        //             return;
        //           }
        //           await generateKrsPdf(
        //             context,
        //           );
        //         },
        // ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ElevatedButton.icon(
            onPressed: krsTersimpan.isEmpty
                ? null
                : () async {
                    final hasPermission = await _requestStoragePermission();
                    if (!hasPermission) {
                      if (mounted) {
                        showSnackbar(
                            context,
                            'Error',
                            'Izin penyimpanan diperlukan untuk download PDF',
                            'error');
                      }
                      return;
                    }
                    await generateKrsPdf(
                      context,
                    );
                  },
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text(
              'Download KRS PDF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  krsTersimpan.isEmpty ? Colors.grey : blueDarkColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () async {
                    setState(() {
                      _isSubmitting = true;
                    });

                    final selectedKrs = <Map<String, dynamic>>[];

                    for (int i = 0; i < isCheckedKrs.length; i++) {
                      if (isCheckedKrs[i]) {
                        final krs = krsTersimpan[i];
                        selectedKrs.add({
                          "IDMAHASISWA": krs['idmahasiswa'],
                          "IDMAKUL": krs['idmakul'],
                          "NAMA": krs['nama'],
                          "SKS": krs['sks'].toString(),
                          "THNAJAR": krs['thnajar'],
                          "SMSTRAJAR": krs['semester'],
                          "THNSM": krs['thnsm'],
                          "SEMESTERMAKUL": krs['semestermakul'],
                          "KELAS": krs['kelas']
                        });
                      }
                    }

                    try {
                      if (selectedKrs.isNotEmpty) {
                        await hapusKRSData(selectedKrs);
                      } else {
                        showSnackbar(context, 'Info',
                            'Pilih minimal 1 mata kuliah', 'info');
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isSubmitting = false;
                        });
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSubmitting ? Colors.grey : Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
              minimumSize: const Size.fromHeight(45),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    'Batalkan Pengajuan KRS',
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const InfoColumn({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: greyDarkTextStyle.copyWith(
              fontSize: 14, fontWeight: semiBold, color: Colors.grey.shade600),
        ),
        Text(value,
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold)),
        const SizedBox(height: 4),
      ],
    );
  }
}

Future<void> generateKrsPdf(BuildContext context) async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Membuat PDF...'),
          ],
        ),
      ),
    );

    // Fetch data from API
    final idMahasiswa = await AuthService().getIdMahasiswa();
    final response = await http.post(
      Uri.parse('$baseUrl/mahasiswa/cetakkrs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': idMahasiswa}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load KRS data');
    }

    final data = jsonDecode(response.body);

    // Extract data from API response
    final namaMahasiswa = data['nama_mahasiswa'] ?? '-';
    final npm = data['id_mahasiswa'] ?? '-';
    final tahunAjaran = data['tahun_ajaran'] ?? '-';
    final semester = data['semester'] ?? '-';
    final programStudi = '${data['prodi'] ?? '-'} / ${data['tingkat'] ?? '-'}';
    final fakultas = data['fakultas'] ?? '-';
    final matakuliah = data['mata_kuliah'] as List<dynamic>;

    // Create PDF document
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(fakultas,
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('KARTU RENCANA STUDI',
                          style: pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Student Information
                pw.Table(
                  border: pw.TableBorder.all(width: 1),
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('NPM',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(npm),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Program / Jenjang Studi',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(programStudi),
                      ),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Nama',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(namaMahasiswa),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Tahun Akademik',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('$tahunAjaran - $semester'),
                      ),
                    ]),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Courses Table
                pw.Table(
                  border: pw.TableBorder.all(width: 1),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(30), // NO
                    1: const pw.FixedColumnWidth(100), // KODE
                    2: const pw.FlexColumnWidth(3), // MATA KULIAH
                    3: const pw.FixedColumnWidth(50), // SKS
                  },
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                              child: pw.Text('NO',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold))),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                              child: pw.Text('KODE',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold))),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                              child: pw.Text('MATA KULIAH',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold))),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                              child: pw.Text('SKS',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold))),
                        ),
                      ],
                    ),
                    // Course rows
                    ...matakuliah.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Center(
                                child: pw.Text((index + 1).toString())),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Center(
                                child: pw.Text(
                                    item['IDMAKUL']?.toString() ?? '-')),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(item['NAMA']?.toString() ?? '-'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Center(
                                child: pw.Text(item['SKS']?.toString() ?? '0')),
                          ),
                        ],
                      );
                    }).toList(),
                    // Total SKS row
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('')),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('')),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('JUMLAH SKS',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                                matakuliah
                                    .fold(
                                        0,
                                        (sum, item) =>
                                            sum +
                                            int.parse(
                                                item['SKS']?.toString() ?? '0'))
                                    .toString(),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Signature section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Pembimbing Akademik'),
                        pw.SizedBox(height: 60),
                        pw.Text('(....................................)'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                            'Batam, ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}'),
                        pw.Text('Mahasiswa'),
                        pw.SizedBox(height: 60),
                        pw.Text(namaMahasiswa),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save PDF to storage
    final directory = await getExternalStorageDirectory();
    final folderPath = '${directory?.path}/KRS';
    await Directory(folderPath).create(recursive: true);

    final fileName = 'KRS_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('$folderPath/$fileName');
    await file.writeAsBytes(await pdf.save());

    // Close loading dialog
    if (context.mounted) {
      Navigator.pop(context);
    }

    // Show confirmation dialog
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('PDF Berhasil Dibuat'),
          content: Text('File tersimpan di: $folderPath/$fileName'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await OpenFile.open(file.path);
              },
              child: const Text('Buka File'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    // Close loading dialog if error
    if (context.mounted) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Gagal membuat PDF: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    debugPrint('Error generating PDF: $e');
  }
}

Future<bool> _requestStoragePermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
  return true;
}

String _getMonthName(int month) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  return months[month - 1];
}

// Alternatif menggunakan Printing.sharePdf
// Future<void> generateAndShareKrsPdf(
//     BuildContext context, List<Map<String, dynamic>> krsTersimpan) async {
//   try {
//     final pdf = pw.Document();

//     // ... sama seperti fungsi di atas ...

//     // Share atau print PDF
//     await Printing.sharePdf(
//       bytes: await pdf.save(),
//       filename: 'KRS_${DateTime.now().millisecondsSinceEpoch}.pdf',
//     );
//   } catch (e) {
//     debugPrint('Error: $e');
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal membuat PDF: $e')),
//       );
//     }
//   }
// }
