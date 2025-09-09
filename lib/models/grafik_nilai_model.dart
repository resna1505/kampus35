class GrafikNilaiModel {
  final String thsmsTrakm;
  final double nilaiIpk;

  GrafikNilaiModel({
    required this.thsmsTrakm,
    required this.nilaiIpk,
  });

  factory GrafikNilaiModel.fromJson(Map<String, dynamic> json) {
    return GrafikNilaiModel(
      thsmsTrakm: json['SEMESTERMHS'] ?? 'Unknown',
      nilaiIpk: double.tryParse(json['NILAIIPK'].toString()) ?? 0.0,
    );
  }
}
