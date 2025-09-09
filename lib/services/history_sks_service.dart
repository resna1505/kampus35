import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/history_sks_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class HistorySksService {
  Future<HistorySksModel> getHistorySks() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/sksmhs',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        HistorySksModel historysks =
            HistorySksModel.fromJson(jsonDecode(res.body));
        return historysks;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
