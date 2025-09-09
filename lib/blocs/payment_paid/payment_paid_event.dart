part of 'payment_paid_bloc.dart';

sealed class PaymentPaidEvent extends Equatable {
  const PaymentPaidEvent();

  @override
  List<Object> get props => [];
}

class PaymentPaidGet extends PaymentPaidEvent {}
