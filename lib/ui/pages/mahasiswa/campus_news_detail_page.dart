import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/information_detail.dart';

class CampusNewsDetail extends StatelessWidget {
  const CampusNewsDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final campusNewsId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Information Detail',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchCampusNewsDetail(campusNewsId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final newsDetail = snapshot.data;
            return ListView(
              children: [
                InformationDetail(
                  title: newsDetail['JUDUL'],
                  from: newsDetail['IDUSER'],
                  subtitle: newsDetail['RINCIAN'],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<dynamic> fetchCampusNewsDetail(String id) async {
    final url =
        'https://ams-api.univbatam.ac.id/index.php/mahasiswa/detailpengumuman/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load news detail');
    }
  }
}
