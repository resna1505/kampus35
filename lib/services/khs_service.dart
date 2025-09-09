import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/khs_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class KhsService {
  Future<List<KhsModel>> getKhs() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/khs',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        return List<KhsModel>.from(
            jsonDecode(res.body).map((khs) => KhsModel.fromJson(khs))).toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
