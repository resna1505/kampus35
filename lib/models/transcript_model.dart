class TranscriptModel {
  final String? tahun;
  final String? semester;
  final String? idmakul;
  final String? namamakul;
  final String? sksmakul;
  final String? simbol;
  final String? bobot;

  TranscriptModel({
    this.tahun,
    this.semester,
    this.idmakul,
    this.namamakul,
    this.sksmakul,
    this.simbol,
    this.bobot,
  });

  factory TranscriptModel.fromJson(Map<String, dynamic> json) =>
      TranscriptModel(
        tahun: json['TAHUN'],
        semester: json['SEMESTER'],
        idmakul: json['IDMAKUL'],
        namamakul: json['NAMA'],
        sksmakul: json['SKS'],
        simbol: json['SIMBOL'],
        bobot: json['BOBOT'],
      );
}
