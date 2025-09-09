import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/transcript_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class TranscriptService {
  Future<List<TranscriptModel>> getTranscript() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/transkrip',
        ),
        body: {
          'id': idmhs,
        },
      );

      if (res.statusCode == 200) {
        return List<TranscriptModel>.from(jsonDecode(res.body)
                .map((transcript) => TranscriptModel.fromJson(transcript)))
            .toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
