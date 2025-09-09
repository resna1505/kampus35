import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/payment_paid_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class PaymentPaidService {
  Future<List<PaymentPaidModel>> getPaymentPaid() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.post(
        Uri.parse(
          '$baseUrl/mahasiswa/riwayatbayar3',
        ),
        body: {
          "id": idmhs,
        },
      );

      if (res.statusCode == 200) {
        return List<PaymentPaidModel>.from(jsonDecode(res.body)
            .map((payment) => PaymentPaidModel.fromJson(payment))).toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
