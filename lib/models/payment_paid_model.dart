class PaymentPaidModel {
  final String? tahun;
  final String? semester;
  final String? komponen;
  final int? biaya;
  final int? sisa;
  final String? tanggal;
  final String? idkomponen;

  PaymentPaidModel({
    this.idkomponen,
    this.komponen,
    this.biaya,
    this.tanggal,
    this.sisa,
    this.tahun,
    this.semester,
  });

  factory PaymentPaidModel.fromJson(Map<String, dynamic> json) =>
      PaymentPaidModel(
        idkomponen: json['IDKOMPONEN'],
        komponen: json['NAMAKOMPONEN'],
        biaya: json['JUMLAHBAYAR'],
        tanggal: json['TANGGALBAYAR'],
        sisa: json['SISA'],
        tahun: json['TAHUN'],
        semester: json['SEMESTER'],
      );
}
