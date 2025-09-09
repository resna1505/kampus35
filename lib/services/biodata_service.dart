import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/biodata_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class BiodataService {
  Future<BiodataModel> getBiodata() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/biodata',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        BiodataModel biodata = BiodataModel.fromJson(jsonDecode(res.body));
        return biodata;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
