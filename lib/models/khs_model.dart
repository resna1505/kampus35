class KhsModel {
  final String? tahun;
  final String? semester;
  final String? idmakul;
  final String? namamakul;
  final String? sksmakul;
  final String? simbol;
  final String? bobot;

  KhsModel({
    this.tahun,
    this.semester,
    this.idmakul,
    this.namamakul,
    this.sksmakul,
    this.simbol,
    this.bobot,
  });

  factory KhsModel.fromJson(Map<String, dynamic> json) => KhsModel(
        tahun: json['TAHUN'],
        semester: json['SEMESTER'],
        idmakul: json['IDMAKUL'],
        namamakul: json['NAMAMAKUL'],
        sksmakul: json['SKSMAKUL'],
        simbol: json['SIMBOL'],
        bobot: json['BOBOT'],
      );
}
