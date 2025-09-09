import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/grafik_nilai_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class GrafikNilaiService {
  Future<List<GrafikNilaiModel>> getGrafikNilai() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/dataipkmhs',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        return List<GrafikNilaiModel>.from(jsonDecode(res.body)
                .map((grafiknilai) => GrafikNilaiModel.fromJson(grafiknilai)))
            .toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
