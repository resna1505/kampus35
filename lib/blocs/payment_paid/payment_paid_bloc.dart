import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/payment_paid_model.dart';
import 'package:kampus/services/payment_paid_service.dart';

part 'payment_paid_event.dart';
part 'payment_paid_state.dart';

class PaymentPaidBloc extends Bloc<PaymentPaidEvent, PaymentPaidState> {
  PaymentPaidBloc() : super(PaymentPaidInitial()) {
    on<PaymentPaidEvent>((event, emit) async {
      if (event is PaymentPaidGet) {
        try {
          emit(PaymentPaidLoading());

          final payment = await PaymentPaidService().getPaymentPaid();
          emit(PaymentPaidSuccess(payment));
        } catch (e) {
          emit(PaymentPaidFailed(e.toString()));
        }
      }
    });
  }
}
