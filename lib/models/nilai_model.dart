class NilaiModel {
  final String? namamakul;
  final String? tahun;
  final String? semester;
  final String? idmakul;
  final String? semestermakul;
  final String? sksmakul;
  final String? simbol;
  final String? nilai;
  final String? kehadiran1;
  final String? tugas1;
  final String? uts;
  final String? kehadiran2;
  final String? tugas2;
  final String? uas;

  NilaiModel({
    this.tahun,
    this.namamakul,
    this.semester,
    this.idmakul,
    this.semestermakul,
    this.sksmakul,
    this.simbol,
    this.nilai,
    this.kehadiran1,
    this.tugas1,
    this.uts,
    this.kehadiran2,
    this.tugas2,
    this.uas,
  });

  factory NilaiModel.fromJson(Map<String, dynamic> json) => NilaiModel(
        tahun: json['TAHUN'],
        semester: json['SEMESTER'],
        idmakul: json['IDMAKUL'],
        semestermakul: json['SEMESTERMAKUL'],
        sksmakul: json['SKSMAKUL'],
        namamakul: json['NAMAMAKUL'],
        nilai: json['NILAI'],
        simbol: json['SIMBOL'],
        kehadiran1: json['KEHADIRAN_1'],
        tugas1: json['TUGAS_1'],
        uts: json['UTS'],
        kehadiran2: json['KEHADIRAN_2'],
        tugas2: json['TUGAS_2'],
        uas: json['UAS'],
      );
}
