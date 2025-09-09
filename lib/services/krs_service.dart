import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/krs_model.dart';
import 'package:kampus/services/auth_service.dart';
// import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class KrsService {
  Future<List<KrsModel>> getKrs() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/krs',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        // List<dynamic> jsonData = jsonDecode(res.body);
        // final detail = jsonData[0]['detail'] as List<dynamic>;
        // return jsonData.map((krs) => KrsModel.fromJson(krs)).toList();
        return List<KrsModel>.from(
            jsonDecode(res.body).map((krs) => KrsModel.fromJson(krs))).toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
