import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/schedule_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class ScheduleService {
  Future<List<ScheduleModel>> getSchedule() async {
    try {
      // final token = await AuthService().getToken();
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/jadwal',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        return List<ScheduleModel>.from(
          jsonDecode(res.body).map(
            (transcript) => ScheduleModel.fromJson(transcript),
          ),
        ).toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
