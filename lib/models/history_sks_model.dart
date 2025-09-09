class HistorySksModel {
  final String? totalsks;
  final String? sksmin;
  final String? skslulus;
  final String? sksmengulang;

  HistorySksModel({
    this.totalsks,
    this.sksmin,
    this.skslulus,
    this.sksmengulang,
  });

  factory HistorySksModel.fromJson(Map<String, dynamic> json) =>
      HistorySksModel(
        totalsks: json['TOTALSKSAMBIL'],
        sksmin: json['SKSMIN'],
        skslulus: json['SKSLULUSMHS'],
        sksmengulang: json['SKSULANGMHS'],
      );
}
