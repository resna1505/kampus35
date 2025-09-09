import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kampus/models/invoice_payment_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_values.dart';

class InvoicePaymentService {
  Future<List<InvoicePaymentModel>> getInvoicePayment() async {
    try {
      final idmhs = await AuthService().getIdMahasiswa();
      final res = await http.get(
        Uri.parse(
          '$baseUrl/mahasiswa/tagihan/$idmhs',
        ),
      );

      if (res.statusCode == 200) {
        // List<dynamic> jsonData = jsonDecode(res.body);
        // final detail = jsonData[0]['detail'] as List<dynamic>;
        // return detail.map((krs) => InvoicePaymentModel.fromJson(krs)).toList();
        return List<InvoicePaymentModel>.from(jsonDecode(res.body)
            .map((krs) => InvoicePaymentModel.fromJson(krs))).toList();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
