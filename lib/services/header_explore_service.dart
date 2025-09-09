import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/header_explorer_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class HeaderExplorerService {
  Future<HeaderExplorerModel> getHeaderExplorer() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/semestermhs',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        HeaderExplorerModel headerexplorer =
            HeaderExplorerModel.fromJson(jsonDecode(res.body));
        return headerexplorer;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
