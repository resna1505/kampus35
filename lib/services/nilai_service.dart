import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kampus/models/nilai_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class NilaiService {
  Future<List<NilaiModel>> getNilai() async {
    try {
      // final token = await AuthService().getToken();
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/detailnilai4',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        return List<NilaiModel>.from(
                jsonDecode(res.body).map((nilai) => NilaiModel.fromJson(nilai)))
            .toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
