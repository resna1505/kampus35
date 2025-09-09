class KrsModel {
  final String? tahun;
  final String? semester;
  final String? idmakul;
  final String? semestermakul;
  final String? sksmakul;
  final String? namamakul;
  final String? name;

  KrsModel({
    this.tahun,
    this.semester,
    this.idmakul,
    this.semestermakul,
    this.sksmakul,
    this.namamakul,
    this.name,
  });

  factory KrsModel.fromJson(Map<String, dynamic> json) => KrsModel(
        tahun: json['tahun'],
        semester: json['semester'],
        idmakul: json['idmakul'],
        semestermakul: json['semestermakul'],
        sksmakul: json['sksmakul'],
        namamakul: json['namamakul'],
        name: json['name'],
      );
}
