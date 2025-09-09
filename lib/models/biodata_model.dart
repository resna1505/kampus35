class BiodataModel {
  final String? idmhs;
  final String? nama;
  final String? namaprodi;
  final String? status;
  final String? idprodi;
  final String? gelombang;
  final String? angkatan;
  final String? foto;

  BiodataModel({
    this.idmhs,
    this.nama,
    this.namaprodi,
    this.status,
    this.idprodi,
    this.gelombang,
    this.angkatan,
    this.foto,
  });

  factory BiodataModel.fromJson(Map<String, dynamic> json) => BiodataModel(
        idmhs: json['ID'],
        nama: json['NAMA'],
        namaprodi: json['NAMAPRODI'],
        status: json['STATUSMAHASISWA'],
        idprodi: json['IDPRODI'],
        gelombang: json['GELOMBANG'],
        angkatan: json['ANGKATAN'],
        foto: json['FOTOURL'],
      );
}
