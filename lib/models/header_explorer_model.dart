class HeaderExplorerModel {
  final String? nama;
  final int? semester;

  HeaderExplorerModel({
    this.nama,
    this.semester,
  });

  factory HeaderExplorerModel.fromJson(Map<String, dynamic> json) =>
      HeaderExplorerModel(
        nama: json['NAMAMAHASISWA'],
        semester: json['SMSTRMAHASISWA'],
      );
}
