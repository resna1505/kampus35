class CampusNewsModel {
  final String? idberita;
  final String? gambar;
  final String? judul;
  final String? sinopsis;
  final String? tanggal;

  CampusNewsModel({
    this.idberita,
    this.gambar,
    this.judul,
    this.sinopsis,
    this.tanggal,
  });

  factory CampusNewsModel.fromJson(Map<String, dynamic> json) =>
      CampusNewsModel(
        idberita: json['ID'],
        gambar: json['GAMBAR'],
        judul: json['JUDUL'],
        sinopsis: json['SINOPSIS'],
        tanggal: json['TANGGALMULAI'],
      );
}
