class AbsenceModel {
  final String? idruangan;
  final String? idmakul;
  final String? namamakul;
  final String? tahun;
  final String? semester;
  final String? tanggal;
  final String? jammulai;
  final int? statusabsen;

  AbsenceModel({
    this.idruangan,
    this.idmakul,
    this.namamakul,
    this.tahun,
    this.semester,
    this.tanggal,
    this.jammulai,
    this.statusabsen,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) => AbsenceModel(
        idruangan: json['IDRUANGAN'],
        idmakul: json['IDMAKUL'],
        namamakul: json['NAMAMAKUL'],
        tahun: json['TAHUN'],
        semester: json['SEMESTER'],
        tanggal: json['TANGGAL'],
        jammulai: json['JAMMULAI'],
        statusabsen: json['STATUSABSEN'],
      );
}
