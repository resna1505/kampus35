class ScheduleModel {
  final String? title;
  final String? subtitle;
  final String? time;
  final String? tanggal;

  ScheduleModel({
    this.title,
    this.subtitle,
    this.time,
    this.tanggal,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        title: json['NAMA'],
        subtitle: json['NAMARUANGAN'],
        time: json['MULAI'],
        tanggal: json['TANGGAL'],
      );
}
