import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/absence_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class AbsenceService {
  Future<List<AbsenceModel>> getAbsence() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.get(
        Uri.parse(
          '$baseUrl/mahasiswa/jadwalabsen/$idmhs',
        ),
      );

      if (res.statusCode == 200) {
        return List<AbsenceModel>.from(jsonDecode(res.body)
            .map((absence) => AbsenceModel.fromJson(absence))).toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmAbsence(String idmakul, String idruangan) async {
    try {
      final token = await AuthService().getToken();
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/postabsen',
        ),
        body: {
          'id': idmhs,
          'idmakul': idmakul,
          'idruangan': idruangan,
        },
        headers: {
          'Authorization': token,
        },
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
