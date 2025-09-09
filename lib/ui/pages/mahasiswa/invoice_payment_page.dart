import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/invoice_payment/invoice_payment_bloc.dart';
import 'package:kampus/blocs/payment_paid/payment_paid_bloc.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/shared_values.dart';
// import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/list_paid.dart';
import 'package:kampus/ui/widgets/list_unpaid.dart';
import 'package:http/http.dart' as http;
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class InvoicePaymentPage extends StatefulWidget {
  const InvoicePaymentPage({
    super.key,
  });

  @override
  State<InvoicePaymentPage> createState() => _InvoicePaymentPageState();
}

class _InvoicePaymentPageState extends State<InvoicePaymentPage> {
  // _InvoicePaymentPageState() {
  //   _selectedVal = _productSizeList[0];
  // }

  // final _productSizeList = [
  //   'Uang Kuliah',
  //   'Wisuda',
  //   'Biaya Konversi',
  //   'perpanjang ktm',
  //   'praktek gerontik',
  //   'Uang KTM',
  // ];
  // String _selectedVal = "Uang Kuliah";

  List<Map<String, dynamic>> _productSizeList = [];
  String _selectedTahunAkademik = '';
  String _selectedTahun = '';
  String _selectedSemester = '';
  String _selectedIdKomponen = '';

  @override
  void initState() {
    super.initState();
    fetchProductSizeList();
  }

  Future<void> fetchProductSizeList() async {
    final idmhs = await AuthService().getIdMahasiswa();
    // final url = '$baseUrl/mahasiswa/tahunakademik/$idmhs';
    final response = await http.post(
      Uri.parse(
        '$baseUrl/mahasiswa/komponenbayar',
      ),
      body: {
        'id': idmhs,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _productSizeList = List.from(data).cast<Map<String, dynamic>>();

        if (_productSizeList.isNotEmpty) {
          _selectedTahunAkademik = _productSizeList[0]['NAMAKOMPONEN'];
          _selectedTahun = _productSizeList[0]['TAHUNAJARAN'];
          _selectedSemester = _productSizeList[0]['SEMESTER'];
          _selectedIdKomponen = _productSizeList[0]['IDKOMPONEN'];
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.5,
          title: Text(
            'Invoice Payment',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
          bottom: TabBar(
            labelColor: purpleColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: const Text(
                  'Unpaid',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: const Text(
                  'Payment History',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) =>
                  InvoicePaymentBloc()..add(InvoicePaymentGet()),
              child: BlocBuilder<InvoicePaymentBloc, InvoicePaymentState>(
                builder: (context, state) {
                  if (state is InvoicePaymentLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 18),
                              Skeleton(
                                height: 12,
                                width: 220,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 12,
                                width: 300,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is InvoicePaymentSuccess) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(top: 24),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                color: whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 4.0,
                                    offset: Offset(0, -4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.invoicePayment
                                    .map((invoicePaymentMethod) {
                                  return ListUnpaid(
                                      invoicePaymentMethod:
                                          invoicePaymentMethod);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        // Bagian Total Billing di luar Expanded agar tetap berada di bawah
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            color: whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4.0,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: greySoftColor),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Billing',
                                      style: greyDarkTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: regular,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  formatCurrency(
                                    state.invoicePayment
                                        .map((invoicePaymentMethod) =>
                                            invoicePaymentMethod.biaya ?? 0)
                                        .fold(0, (prev, biaya) => prev + biaya),
                                  ),
                                  style: redTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(top: 12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/img_no_data.png'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: 'Oops! Sepertinya kamu tidak\nmemiliki ',
                              style: blackTextStyle.copyWith(fontSize: 12),
                              children: [
                                TextSpan(
                                  text: 'Invoice Payment',
                                  style: blueTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' hari ini',
                                  style: blackTextStyle.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            BlocProvider(
              create: (context) => PaymentPaidBloc()..add(PaymentPaidGet()),
              child: BlocBuilder<PaymentPaidBloc, PaymentPaidState>(
                builder: (context, state) {
                  if (state is PaymentPaidLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 18),
                              Skeleton(
                                height: 12,
                                width: 220,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 12,
                                width: 300,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                              SizedBox(height: 8),
                              Skeleton(
                                height: 115,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is PaymentPaidSuccess) {
                    final filteredPaid =
                        state.paymentPaid.where((paymentPaidMethod) {
                      return paymentPaidMethod.tahun == _selectedTahun &&
                          paymentPaidMethod.semester == _selectedSemester &&
                          paymentPaidMethod.idkomponen == _selectedIdKomponen;
                    }).toList();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true, // Tambahkan properti ini
                            value: _selectedTahunAkademik.isNotEmpty
                                ? _selectedTahunAkademik
                                : null,
                            items: _productSizeList.map((e) {
                              return DropdownMenuItem<String>(
                                value: e['NAMAKOMPONEN'],
                                child: Text(e['NAMAKOMPONEN']),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedTahunAkademik = val ?? '';
                                _selectedTahun = _productSizeList.firstWhere(
                                        (e) => e['NAMAKOMPONEN'] == val)[
                                    'TAHUNAJARAN'];
                                _selectedSemester = _productSizeList.firstWhere(
                                    (e) =>
                                        e['NAMAKOMPONEN'] == val)['SEMESTER'];
                                _selectedIdKomponen =
                                    _productSizeList.firstWhere((e) =>
                                        e['NAMAKOMPONEN'] == val)['IDKOMPONEN'];
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: purpleColor,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Pilih Tahun Akademik',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: filteredPaid.isEmpty
                                ? Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          margin:
                                              const EdgeInsets.only(top: 12),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/img_no_data.png'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            text:
                                                'Oops! Sepertinya kamu tidak\nmemiliki ',
                                            style: blackTextStyle.copyWith(
                                                fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: 'Invoice Payment',
                                                style: blueTextStyle.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' hari ini',
                                                style: blackTextStyle.copyWith(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      color: whiteColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 4.0,
                                          offset: Offset(0, -4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          filteredPaid.map((paymentPaidMethod) {
                                        return ListPaid(
                                            paymentPaidMethod:
                                                paymentPaidMethod);
                                      }).toList(),
                                    ),
                                  ),
                          ),
                        ),
                        // const Spacer(),
                        // Container(
                        //   padding: const EdgeInsets.all(24),
                        //   decoration: BoxDecoration(
                        //     borderRadius: const BorderRadius.only(
                        //       topLeft: Radius.circular(16),
                        //       topRight: Radius.circular(16),
                        //     ),
                        //     color: whiteColor,
                        //     boxShadow: const [
                        //       BoxShadow(
                        //         color: Colors.grey,
                        //         blurRadius: 4.0,
                        //         offset: Offset(0, -2),
                        //       ),
                        //     ],
                        //   ),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       border: Border(
                        //         bottom: BorderSide(color: greySoftColor),
                        //       ),
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'Sisa Pembayaran',
                        //               style: greyDarkTextStyle.copyWith(
                        //                 fontSize: 12,
                        //                 fontWeight: regular,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         const SizedBox(
                        //           height: 4,
                        //         ),
                        //         Text(
                        //           state.invoicePayment.first.id.toString(),
                        //           style: redTextStyle.copyWith(
                        //             fontSize: 16,
                        //             fontWeight: semiBold,
                        //           ),
                        //         ),
                        //         const SizedBox(
                        //           height: 4,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(top: 12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/img_no_data.png'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: 'Oops! Sepertinya kamu tidak\nmemiliki ',
                              style: blackTextStyle.copyWith(fontSize: 12),
                              children: [
                                TextSpan(
                                  text: 'Invoice Payment',
                                  style: blueTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' hari ini',
                                  style: blackTextStyle.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
