part of 'invoice_payment_bloc.dart';

sealed class InvoicePaymentState extends Equatable {
  const InvoicePaymentState();

  @override
  List<Object> get props => [];
}

final class InvoicePaymentInitial extends InvoicePaymentState {}

final class InvoicePaymentLoading extends InvoicePaymentState {}

final class InvoicePaymentFailed extends InvoicePaymentState {
  final String e;
  const InvoicePaymentFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class InvoicePaymentSuccess extends InvoicePaymentState {
  final List<InvoicePaymentModel> invoicePayment;

  const InvoicePaymentSuccess(this.invoicePayment);

  @override
  List<Object> get props => [invoicePayment];
}
