part of 'payment_paid_bloc.dart';

sealed class PaymentPaidState extends Equatable {
  const PaymentPaidState();

  @override
  List<Object> get props => [];
}

final class PaymentPaidInitial extends PaymentPaidState {}

final class PaymentPaidLoading extends PaymentPaidState {}

final class PaymentPaidFailed extends PaymentPaidState {
  final String e;
  const PaymentPaidFailed(this.e);

  @override
  List<Object> get props => [e];
}

// final class PaymentPaidSuccess extends PaymentPaidState {
//   final List<PaymentPaidModel> paymentPaid;

//   const PaymentPaidSuccess(this.paymentPaid);

//   @override
//   List<Object> get props => [paymentPaid];
// }
final class PaymentPaidSuccess extends PaymentPaidState {
  final List<PaymentPaidModel> paymentPaid;

  const PaymentPaidSuccess(this.paymentPaid);

  @override
  List<Object> get props => [paymentPaid];
}
