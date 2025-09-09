import 'package:flutter/material.dart';
import 'package:kampus/models/invoice_payment_model.dart';
import 'package:kampus/shared/shared_methods.dart';
import 'package:kampus/shared/theme.dart';

class ListUnpaid extends StatelessWidget {
  // final String komponen;
  // final String biaya;
  // final String tanggal;
  final InvoicePaymentModel invoicePaymentMethod;

  const ListUnpaid({
    super.key,
    // required this.komponen,
    // required this.biaya,
    // required this.tanggal,

    required this.invoicePaymentMethod,
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
                    invoicePaymentMethod.komponen.toString(),
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                    ),
                  ),
                  Text(
                    formatCurrency(invoicePaymentMethod.biaya!),
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
                    'Jatuh Tempo : ',
                    style: greyTextStyle.copyWith(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    invoicePaymentMethod.tanggal.toString(),
                    style: redTextStyle.copyWith(
                      fontSize: 10,
                      fontWeight: semiBold,
                    ),
                  )
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
