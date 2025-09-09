import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';

class LecturerConsultationPage extends StatefulWidget {
  const LecturerConsultationPage({super.key});

  @override
  State<LecturerConsultationPage> createState() =>
      _LecturerConsultationPageState();
}

class _LecturerConsultationPageState extends State<LecturerConsultationPage> {
  _LecturerConsultationPageState() {
    _selectedVal = _productSizeList[0];
  }

  // final _productController = TextEditingController();
  // final _productDesController = TextEditingController();
  // bool? _topProduct = false;
  // ProductTypeEnum? _productTypeEnum;

  final _productSizeList = [
    '2021/2022 Genap',
    '2021/2022 Gasal',
    '2020/2021 Genap',
    '2020/2021 Gasal',
    '2019/2020 Genap',
    '2019/2020 Gasal',
  ];
  String _selectedVal = "2021/2022 Genap";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        title: Text(
          'Konsultasi Dosen',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField(
                  value: _selectedVal,
                  items: _productSizeList
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _selectedVal = val as String;
                      },
                    );
                  },
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: purpleColor,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Pilih Periode',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: greySoftColor,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/notification.jpg',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HANAFI, S.KOM., M.Kom',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: semiBold,
                              ),
                            ),
                            Text(
                              '8873810016',
                              style: blackTextStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Pembimbing Akademik',
                              style: greyTextStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
