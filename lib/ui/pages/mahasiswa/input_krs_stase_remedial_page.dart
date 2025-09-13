import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/shared_values.dart';
import 'package:kampus/shared/theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  List<Map<String, dynamic>> mataKuliah = [];
  List<Map<String, dynamic>> lokasiOptions = [];
  List<Map<String, dynamic>> krsTersimpan = [];

  int? selectedMataKuliahIndex;
  String? selectedLokasiId;

  bool _isSubmitting = false;

  // Data dari API
  String semester = '-';
  String periodeAkademik = '-';
  String batasSKS = '-';
  String idMahasiswa = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchLokasiOptions();
    await fetchKRSData();
    await fetchKRSTersimpan();
  }

  Future<void> fetchLokasiOptions() async {
    final url = Uri.parse('$baseUrl/akademik/lokasi');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          lokasiOptions = data.map<Map<String, dynamic>>((item) {
            return {'ID': item['ID'] ?? '-', 'LOKASI': item['LOKASI'] ?? '-'};
          }).toList();
        });
      } else {
        if (mounted) {
          showSnackbar(context, 'Info', 'Gagal mengambil data lokasi', 'info');
        }
      }
    } catch (e) {
      debugPrint('Error fetch lokasi options: $e');
      if (mounted) {
        showSnackbar(context, 'Error', 'Gagal mengambil data lokasi', 'error');
      }
    }
  }

  Future<void> fetchKRSData() async {
    final idmhs = await AuthService().getIdMahasiswa();
    final url = Uri.parse('$baseUrl/mahasiswa/isikrsremedialprofesi');

    try {
      final request = http.Request('GET', url);
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({'id': idmhs});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> mataKuliahData = data['mata_kuliah'] ?? [];

        setState(() {
          idMahasiswa = data['id_mahasiswa'] ?? '-';
          semester = data['semester']?.toString() ?? '-';
          periodeAkademik = data['tahun_ajaran'] ?? '-';
          batasSKS = data['batas_sks']?.toString() ?? '-';

          mataKuliah = mataKuliahData.map<Map<String, dynamic>>((item) {
            return {
              'ID': item['ID'] ?? '-',
              'NAMA': item['NAMA'] ?? '-',
              'KDWPLTBKMK': item['KDWPLTBKMK'] ?? '-',
              'SKS': item['SKS'] ?? '0',
              'SEMESTER': item['SEMESTER'] ?? '-',
              'THSMSTBKMK': item['THSMSTBKMK'] ?? '-',
              'idmahasiswa': item['idmahasiswa'] ?? '-',
              'tahunajaran': item['tahunajaran'] ?? '-',
              'semesterajaran': item['semesterajaran'] ?? '-',
            };
          }).toList();
        });
      } else {
        if (mounted) {
          showSnackbar(context, 'Info', 'Error ${response.statusCode}', 'info');
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Error', 'Gagal mengambil data', 'error');
      }
    }
  }

  Future<void> fetchKRSTersimpan() async {
    final idmhs = await AuthService().getIdMahasiswa();
    final url = Uri.parse('$baseUrl/mahasiswa/ambilmatkulkrsremedialprofesi');

    try {
      final request = http.Request('GET', url);
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({'id': idmhs});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          krsTersimpan = data.map<Map<String, dynamic>>((item) {
            return {
              "IDMAHASISWA": item['IDMAHASISWA'] ?? '-',
              "IDMAKUL": item['IDMAKUL'] ?? '-',
              "NAMA": item['NAMA'] ?? '-',
              "SKS": item['SKS'] ?? '0',
              "THNAJAR": item['THNAJAR'] ?? '-',
              "SMSTRAJAR": item['SMSTRAJAR'] ?? '-',
              "THNSM": item['THNSM'] ?? '-',
              "SEMESTERMAKUL": item['SEMESTERMAKUL'] ?? '-',
              "KELAS": item['KELAS'] ?? '-',
              "IDLOKASI": item['IDLOKASI'] ?? '-',
              "LOKASI": item['LOKASI'] ?? '-',
            };
          }).toList();
        });
      } else if (response.statusCode == 404) {
        setState(() {
          krsTersimpan = [];
        });
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          showSnackbar(
            context,
            'Info',
            data['messages']?['error'] ?? 'Error mengambil data',
            'info',
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetch KRS Tersimpan: $e');
      if (mounted) {
        setState(() {
          krsTersimpan = [];
        });
        showSnackbar(
          context,
          'Error',
          'Gagal memuat data KRS tersimpan',
          'error',
        );
      }
    }
  }

  Future<void> postKRSData() async {
    if (selectedMataKuliahIndex == null || selectedLokasiId == null) {
      showSnackbar(context, 'Info', 'Pilih mata kuliah dan lokasi', 'info');
      return;
    }

    final selectedMatkul = mataKuliah[selectedMataKuliahIndex!];
    final url = Uri.parse('$baseUrl/mahasiswa/postisikrsremedialprofesi');

    final requestData = {
      "ID": selectedMatkul['ID'],
      "NAMA": selectedMatkul['NAMA'],
      "KDWPLTBKMK": selectedMatkul['KDWPLTBKMK'],
      "SKS": selectedMatkul['SKS'],
      "SEMESTER": selectedMatkul['SEMESTER'],
      "THSMSTBKMK": selectedMatkul['THSMSTBKMK'],
      "idmahasiswa": selectedMatkul['idmahasiswa'],
      "tahunajaran": selectedMatkul['tahunajaran'],
      "semesterajaran": selectedMatkul['semesterajaran'],
      "KELAS": "01", // Default class
      "lokasimakul": selectedLokasiId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          if (mounted) {
            showSnackbar(
              context,
              'Success',
              responseData['message'],
              'success',
            );
            await fetchKRSTersimpan(); // Refresh data tersimpan
            setState(() {
              selectedMataKuliahIndex = null;
              selectedLokasiId = null;
            });
          }
        } else {
          if (mounted) {
            showSnackbar(
              context,
              'Info',
              responseData['message'] ?? 'Gagal menyimpan',
              'info',
            );
          }
        }
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          showSnackbar(
            context,
            'Error',
            data['message'] ?? 'Terjadi kesalahan',
            'error',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Error', 'Gagal menyimpan: $e', 'error');
      }
    }
  }

  Future<void> hapusKRSData(Map<String, dynamic> krsItem) async {
    final url = Uri.parse('$baseUrl/mahasiswa/hapusisikrsremedialprofesi');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(krsItem),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          if (mounted) {
            showSnackbar(
              context,
              'Success',
              responseData['message'],
              'success',
            );
            await fetchKRSTersimpan(); // Refresh data
          }
        } else {
          if (mounted) {
            showSnackbar(
              context,
              'Info',
              responseData['message'] ?? 'Gagal menghapus',
              'info',
            );
          }
        }
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          showSnackbar(
            context,
            'Error',
            data['message'] ?? 'Terjadi kesalahan',
            'error',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Error', 'Gagal menghapus: $e', 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: whiteColor,
        title: Text(
          'KRS Stase Remedial',
          style: blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
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
                  InfoColumn(title: 'Tahun Ajaran', value: periodeAkademik),
                  InfoColumn(title: 'Semester', value: semester),
                  // InfoColumn(title: 'Batas SKS', value: batasSKS),
                ],
              ),
            ),
          ),

          // Tabs
          Row(
            children: [
              _buildTabButton('PILIH MATA KULIAH', 0),
              _buildTabButton('MATA KULIAH TERSIMPAN', 1),
            ],
          ),

          // Content per tab
          Expanded(
            child: selectedTab == 0
                ? _buildPilihMataKuliah()
                : _buildKRSTersimpan(),
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
                  .copyWith(fontSize: 12, fontWeight: semiBold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPilihMataKuliah() {
    return Column(
      children: [
        // Info card about single selection
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Anda hanya dapat memilih SATU mata kuliah stase per periode. Pilih lokasi yang tersedia.',
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: mataKuliah.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img_no_data.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada mata kuliah stase\nyang tersedia',
                        style: blackTextStyle.copyWith(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: mataKuliah.length,
                  itemBuilder: (context, index) {
                    final matkul = mataKuliah[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<int>(
                                  value: index,
                                  groupValue: selectedMataKuliahIndex,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMataKuliahIndex = value;
                                      selectedLokasiId =
                                          null; // Reset lokasi selection
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        matkul['NAMA'],
                                        style: blackTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                      Text(
                                        'SKS ${matkul['SKS']} • ${matkul['ID']}',
                                        style: blackTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Semester ${matkul['SEMESTER']}',
                                        style: blackTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Lokasi selection untuk mata kuliah yang dipilih
                            if (selectedMataKuliahIndex == index) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                              Text(
                                'Pilih Lokasi Stase:',
                                style: blackTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: semiBold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...lokasiOptions.map((lokasi) {
                                return RadioListTile<String>(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    lokasi['LOKASI'],
                                    style: blackTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  value: lokasi['ID'],
                                  groupValue: selectedLokasiId,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLokasiId = value;
                                    });
                                  },
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Submit button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _isSubmitting ||
                      selectedMataKuliahIndex == null ||
                      selectedLokasiId == null
                  ? null
                  : () async {
                      setState(() {
                        _isSubmitting = true;
                      });

                      try {
                        await postKRSData();
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isSubmitting = false;
                          });
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSubmitting
                    ? Colors.green[300]
                    : Colors.green,
                foregroundColor: whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
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
                      'Daftar Stase',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKRSTersimpan() {
    int totalSKS = krsTersimpan.fold(
      0,
      (sum, item) => sum + int.parse(item['SKS'].toString()),
    );

    return Column(
      children: [
        Expanded(
          child: krsTersimpan.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img_no_data.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada KRS Stase\nyang terdaftar',
                        style: blackTextStyle.copyWith(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: krsTersimpan.length,
                  itemBuilder: (context, index) {
                    final item = krsTersimpan[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['NAMA'],
                                        style: blackTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'SKS: ${item['SKS']} • Kode: ${item['IDMAKUL']}',
                                        style: blackTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Lokasi: ${item['LOKASI']} • Kelas: ${item['KELAS']}',
                                        style: blackTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Semester: ${item['SEMESTERMAKUL']} • ${item['THNAJAR']}',
                                        style: blackTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Konfirmasi'),
                                        content: Text(
                                          'Hapus mata kuliah ${item['NAMA']}?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await hapusKRSData(item);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Status and actions
        if (krsTersimpan.isNotEmpty) ...[
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
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'KRS Stase telah didaftarkan',
                      style: greenTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${krsTersimpan.length} mata kuliah ($totalSKS SKS)',
                  style: blackTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Download PDF button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final hasPermission = await _requestStoragePermission();
                if (!hasPermission) {
                  if (mounted) {
                    showSnackbar(
                      context,
                      'Error',
                      'Izin penyimpanan diperlukan untuk download PDF',
                      'error',
                    );
                  }
                  return;
                }
                await generateKrsStasePdf(context, krsTersimpan);
              },
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text(
                'Download KRS Stase PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: blueDarkColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],

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
            fontSize: 14,
            fontWeight: semiBold,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

Future<void> generateKrsStasePdf(
  BuildContext context,
  List<Map<String, dynamic>> krsTersimpan,
) async {
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
                      pw.Text(
                        'UNIVERSITAS BATAM',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'KARTU RENCANA STUDI STASE',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Student Information
                if (krsTersimpan.isNotEmpty) ...[
                  pw.Table(
                    border: pw.TableBorder.all(width: 1),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Center(
                              child: pw.Text(
                                'LOKASI',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Center(
                              child: pw.Text(
                                'SKS',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Stase rows
                      ...krsTersimpan.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Center(
                                child: pw.Text((index + 1).toString()),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Center(
                                child: pw.Text(
                                  item['IDMAKUL']?.toString() ?? '-',
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(item['NAMA']?.toString() ?? '-'),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(item['LOKASI']?.toString() ?? '-'),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Center(
                                child: pw.Text(item['SKS']?.toString() ?? '0'),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      // Total SKS row
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey100,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Center(
                              child: pw.Text(
                                'JUMLAH SKS',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(''),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Center(
                              child: pw.Text(
                                krsTersimpan
                                    .fold(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          int.parse(
                                            item['SKS']?.toString() ?? '0',
                                          ),
                                    )
                                    .toString(),
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
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
                          pw.Text('Koordinator Stase'),
                          pw.SizedBox(height: 60),
                          pw.Text('(....................................)'),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Batam, ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                          ),
                          pw.Text('Mahasiswa'),
                          pw.SizedBox(height: 60),
                          pw.Text(
                            krsTersimpan.isNotEmpty
                                ? krsTersimpan.first['IDMAHASISWA']
                                : '',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );

    // Save PDF to storage
    final directory = await getExternalStorageDirectory();
    final folderPath = '${directory?.path}/KRS_Stase';
    await Directory(folderPath).create(recursive: true);

    final fileName = 'KRS_Stase_${DateTime.now().millisecondsSinceEpoch}.pdf';
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
    'Desember',
  ];
  return months[month - 1];
}
