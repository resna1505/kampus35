import 'package:flutter/material.dart';
import 'package:kampus/models/payment_paid_model.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/theme.dart';

class ListPaid extends StatelessWidget {
  // final String komponen;
  // final String biaya;
  // final String tanggal;
  final PaymentPaidModel paymentPaidMethod;

  const ListPaid({
    super.key,
    // required this.komponen,
    // required this.biaya,
    // required this.tanggal,
    required this.paymentPaidMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: greySoftColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    paymentPaidMethod.komponen.toString(),
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                    ),
                  ),
                  Text(
                    formatCurrency(paymentPaidMethod.biaya!),
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    'Tanggal : ',
                    style: greyTextStyle.copyWith(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    paymentPaidMethod.tanggal.toString(),
                    style: redTextStyle.copyWith(
                      fontSize: 10,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Spacer(),
                  Text(
                    'Sisa Tagihan : ',
                    style: greyTextStyle.copyWith(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    formatCurrency(paymentPaidMethod.sisa!),
                    style: redTextStyle.copyWith(
                      fontSize: 10,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
