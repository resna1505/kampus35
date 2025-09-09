import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class UserService {
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    try {
      final token = await AuthService().getToken();
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/ubah_password',
        ),
        body: {
          'id': idmhs,
          'passlama': oldPassword,
          'pass': newPassword,
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
