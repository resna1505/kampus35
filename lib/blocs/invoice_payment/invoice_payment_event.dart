part of 'invoice_payment_bloc.dart';

sealed class InvoicePaymentEvent extends Equatable {
  const InvoicePaymentEvent();

  @override
  List<Object> get props => [];
}

class InvoicePaymentGet extends InvoicePaymentEvent {}
