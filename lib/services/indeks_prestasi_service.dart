import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/indeks_prestasi_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class IndeksPrestasiService {
  Future<IndeksPrestasiModel> getIndeksPrestasi() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/ipsipkmhs',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        IndeksPrestasiModel indeksprestasi =
            IndeksPrestasiModel.fromJson(jsonDecode(res.body));
        return indeksprestasi;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
